#ifndef __PROCESSRGB_HPP__
#define __PROCESSRGB_HPP__

#include <stdint.h>

void CompressEtc1Alpha( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );
void CompressEtc2Alpha( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );
void CompressEtc1Rgb( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );
void CompressEtc1RgbDither( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );
void CompressEtc2Rgb( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );
void CompressEtc2Rgba( const uint32_t* src, uint64_t* dst, uint32_t blocks, size_t width );

#endif
