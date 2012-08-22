// qt-mxf-audio.cpp : Defines the entry point for the console application.
//

#include <QCoreApplication>

#include <windows.h>
#include <xaudio2.h>

#include <KM_fileio.h>
#include <KM_prng.h>
#include <PCMParserList.h>
#include <WavFileWriter.h>
#include <MXF.h>
#include <Metadata.h>
#include <openssl/sha.h>

#include <iostream>
#include <assert.h>

#include <deque>

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif
#include <boost/utility.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/shared_array.hpp>
#include <boost/chrono.hpp>


class pcm_buffer : private boost::noncopyable
{
public:
    size_t length;
    boost::shared_array<BYTE> buffer;
};

typedef boost::shared_ptr<pcm_buffer> pcm_buffer_ptr;
typedef std::deque<pcm_buffer_ptr> pcm_buffer_ptr_list_t;

pcm_buffer_ptr_list_t pcm_array;

//--------------------------------------------------------------------------------------
// Callback structure
//--------------------------------------------------------------------------------------
struct StreamingVoiceContext : public IXAudio2VoiceCallback
{
    STDMETHOD_( void, OnVoiceProcessingPassStart )( UINT32 )
    {
    }
    STDMETHOD_( void, OnVoiceProcessingPassEnd )()
    {
    }
    STDMETHOD_( void, OnStreamEnd )()
    {
    }
    STDMETHOD_( void, OnBufferStart )( void* )
    {
    }
    STDMETHOD_( void, OnBufferEnd )( void* )
    {
        SetEvent( hBufferEndEvent );
    }
    STDMETHOD_( void, OnLoopEnd )( void* )
    {
    }
    STDMETHOD_( void, OnVoiceError )( void*, HRESULT )
    {
    }

    HANDLE hBufferEndEvent;

    StreamingVoiceContext() : hBufferEndEvent( CreateEvent( NULL, FALSE, FALSE, NULL ) )
    {
    }
    virtual ~StreamingVoiceContext()
    {
        CloseHandle( hBufferEndEvent );
    }
};


IXAudio2* audio_engine = NULL;
IXAudio2MasteringVoice* master_voice = NULL;
IXAudio2SourceVoice* source_voice = NULL;
StreamingVoiceContext voiceContext;
XAUDIO2_BUFFER buffer = {0};

/* Initialize audio module */
bool init_audio()
{
    if (FAILED(CoInitializeEx(0, COINIT_MULTITHREADED))) {
        puts("coinitialize error!");
        return false;
    }

    if (SUCCEEDED(XAudio2Create(&audio_engine))) {
        if (SUCCEEDED(audio_engine->CreateMasteringVoice(&master_voice, XAUDIO2_DEFAULT_CHANNELS, XAUDIO2_DEFAULT_SAMPLERATE, 0, 0, 0))) {
            puts("init xaudio2!");
            return true;
        }
    }

    return false;
}


/* -- Close and shutdown audio module -- */
void shutdown_audio()
{
    if (source_voice) {
        source_voice->DestroyVoice();
        source_voice = NULL;
    }

    if (master_voice) {
        master_voice->DestroyVoice();
        master_voice = NULL;
    }

    if (audio_engine) {
        audio_engine->Release();
    }
    CoUninitialize();
}


using namespace ASDCP;

const ui32_t FRAME_BUFFER_SIZE = 4 * Kumu::Megabyte;



Result_t
    read_PCM_file(const char* filename)
{
    AESDecContext*     Context = 0;
    HMACContext*       HMAC = 0;
    PCM::MXFReader     Reader;
    PCM::FrameBuffer   FrameBuffer;
    WavFileWriter      OutWave;
    PCM::AudioDescriptor ADesc;
    ui32_t last_frame = 0;
    ui32_t start_frame = 0;

    Result_t result = Reader.OpenRead(filename);

    if ( ASDCP_SUCCESS(result) ) {
        Reader.FillAudioDescriptor(ADesc);

        if ( ADesc.EditRate != EditRate_23_98
            && ADesc.EditRate != EditRate_24
            && ADesc.EditRate != EditRate_25
            && ADesc.EditRate != EditRate_30
            && ADesc.EditRate != EditRate_48
            && ADesc.EditRate != EditRate_50
            && ADesc.EditRate != EditRate_60 )
            ADesc.EditRate = EditRate_24;

        FrameBuffer.Capacity(PCM::CalcFrameBufferSize(ADesc));
    }

    WAVEFORMATEX format;
    format.cbSize = 0;
    format.nAvgBytesPerSec = ADesc.AvgBps;
    format.nChannels = ADesc.ChannelCount;
    format.nBlockAlign = ADesc.BlockAlign;
    format.nSamplesPerSec = (DWORD) ADesc.AudioSamplingRate.Quotient();
    format.wBitsPerSample = ADesc.QuantizationBits;
    format.wFormatTag = 1; // WAVE_FORMAT_PCM;

    audio_engine->CreateSourceVoice(&source_voice, &format, 0, XAUDIO2_MAX_FILTER_FREQUENCY /*XAUDIO2_DEFAULT_FREQ_RATIO*/, &voiceContext, 0, 0);

    if ( ASDCP_SUCCESS(result) ) {
        last_frame = ADesc.ContainerDuration;

        ADesc.ContainerDuration = last_frame - start_frame;
    }

    printf("ADesc.ChannelCount = %d\n", ADesc.ChannelCount);
    printf("ADesc.QuantizationBits = %d\n", ADesc.QuantizationBits);
    printf("ADesc.BlockAlign = %d\n", ADesc.BlockAlign);

    for ( ui32_t i = start_frame; ASDCP_SUCCESS(result) && i < last_frame; i++ ) {
        result = Reader.ReadFrame(i, FrameBuffer, Context, HMAC);

        if ( ASDCP_SUCCESS(result) ) {
            pcm_buffer_ptr pbuffer = boost::shared_ptr<pcm_buffer>(new pcm_buffer);
            pbuffer->buffer = boost::shared_array<BYTE> (new BYTE[FrameBuffer.Size()]);
            memcpy(pbuffer->buffer.get(), FrameBuffer.RoData(), FrameBuffer.Size());
            pbuffer->length = FrameBuffer.Size();
            pcm_array.push_back(pbuffer);
        }
    }

    boost::chrono::system_clock::time_point play_start = boost::chrono::system_clock::now();

    for (int i = 0; i < pcm_array.size(); i++) {

        boost::chrono::system_clock::time_point start = boost::chrono::system_clock::now();
        // boost::this_thread::sleep_for(boost::chrono::nanoseconds(1600000));

        buffer.pAudioData = pcm_array[i]->buffer.get();
        // buffer.Flags = XAUDIO2_END_OF_STREAM;
        buffer.AudioBytes = pcm_array[i]->length;
        if (SUCCEEDED(source_voice->SubmitSourceBuffer(&buffer))) {
            HRESULT hr = source_voice->Start(0, XAUDIO2_COMMIT_NOW);

            XAUDIO2_VOICE_STATE state;
            for(;;) {
                source_voice->GetState(&state);
                if (state.BuffersQueued < 5 )
                    break;
                WaitForSingleObject(voiceContext.hBufferEndEvent, INFINITE);
            }
        }

        boost::chrono::nanoseconds sec  = boost::chrono::system_clock::now() - start;
        std::cout << "took " << sec.count() / 1000 / 1000.0 << " ms.\n";
    }

    boost::chrono::nanoseconds play_sec  = boost::chrono::system_clock::now() - play_start;
    std::cout << "===> total playing took " << play_sec.count() / 1000 / 1000.0 << " ms.\n";

    return result;
}



int main(int argc, char *argv[])
{
    if (argc < 2) {
        printf("usage: %s mxf-audio-file\n", argv[0]);
        return -1;
    }

    QCoreApplication a(argc, argv);

    init_audio();

    read_PCM_file(argv[1]);

    shutdown_audio();

    return 0; // a.exec();
}
