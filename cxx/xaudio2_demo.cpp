#include<windows.h>
#include<iostream>
#include<xaudio2.h>
#include"SDKwavefile.h"

using namespace std;

int main(int args, char* argc[])
{
    cout <<"XAudio2 Demo!" << endl << endl;
    if( FAILED( CoInitializeEx( 0, COINIT_MULTITHREADED ) ) )
        return 0;
    IXAudio2* xAudio2Engine = 0;
    UINT32 flags = 0;
#ifdef _DEBUG
    flags |= XAUDIO2_DEBUG_ENGINE;
#endif
    if( SUCCEEDED( XAudio2Create( &xAudio2Engine ) ) ) {
        IXAudio2MasteringVoice* masterVoice = 0;
        if( SUCCEEDED( xAudio2Engine->CreateMasteringVoice( &masterVoice,
                       XAUDIO2_DEFAULT_CHANNELS, XAUDIO2_DEFAULT_SAMPLERATE, 0, 0, 0 ) ) ) {
            CWaveFile wav;
            if( SUCCEEDED( wav.Open("clip.wav", 0, WAVEFILE_READ ) ) ) {
                WAVEFORMATEX *format = wav.GetFormat( );
                unsigned long wavSize = wav.GetSize( );
                unsigned char *wavData = new unsigned char[wavSize];
                if( SUCCEEDED( wav.Read( wavData, wavSize, &wavSize ) ) ) {
                    IXAudio2SourceVoice* srcVoice;
                    if( SUCCEEDED( xAudio2Engine->CreateSourceVoice( &srcVoice,
                                   format, 0, XAUDIO2_DEFAULT_FREQ_RATIO, 0, 0, 0 ) ) ) {
                        XAUDIO2_BUFFER buffer = { 0 };
                        buffer.pAudioData = wavData;
                        buffer.Flags = XAUDIO2_END_OF_STREAM;
                        buffer.AudioBytes = wavSize;

                        if(SUCCEEDED( srcVoice->SubmitSourceBuffer( &buffer
                                                                  ) )) {
                            HRESULT hr = srcVoice->Start(0, XAUDIO2_COMMIT_NOW);
                            bool isRunning = true;
                            while( SUCCEEDED( hr ) && isRunning ) {
                                XAUDIO2_VOICE_STATE state;
                                srcVoice->GetState( &state );
                                isRunning = ( state.BuffersQueued > 0 ) != 0;
                            }
                        }
                    }
                    if( srcVoice )
                        srcVoice->DestroyVoice( );
                }
                if( wavData )
                    delete[] wavData;
            }
        }
    }
    if( xAudio2Engine != 0 )
        xAudio2Engine->Release( );
    CoUninitialize( );
    return 1;
}
