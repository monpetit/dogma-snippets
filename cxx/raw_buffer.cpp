
#include <boost/utility.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/shared_array.hpp>
#include <iostream>


template<typename T>
class raw_buffer : private boost::noncopyable
{
public:
    size_t size;
    boost::shared_array<T> data;
    raw_buffer(size_t _size) : size(_size) {
        data = boost::shared_array<T> (new T[size]);
    }
    ~raw_buffer() {
        data.reset();
    }

	void assign(T* src_data, size_t src_size) {
		memcpy(data.get(), source, src_size);
	}

    T* get_data() {
        return data.get();
    }
};


#ifdef _STANDALONE

typedef unsigned char byte_t;
typedef boost::shared_ptr<raw_buffer<byte_t> > raw_buffer_ptr_t;


int main(void)
{
	raw_buffer_ptr_t frame(new raw_buffer<byte_t>(10000));
	std::cout << frame->size << std::endl;
	memset(frame->get_data(), 'A', frame->size * sizeof(byte_t));
	frame->get_data()[frame->size-1] = 0x00;
	std::cout << '|' << frame->get_data() << '|' << std::endl;

	return 0;
}

#endif
