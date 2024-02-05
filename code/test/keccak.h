#ifndef KECCAK_H
#define KECCAK_H

#include <stddef.h>
#include <stdint.h>

#define NROUNDS 24

/* Function Prototypes */

uint64_t load64(const uint8_t* x);
void store64(uint8_t* x, uint64_t u);
void KeccakF1600_StatePermute(uint64_t* state);
void keccak_absorb(uint64_t* s, uint32_t r, const uint8_t* m, size_t mlen, uint8_t p);
void keccak_squeezeblocks(uint8_t* h, size_t nblocks, uint64_t* s, uint32_t r);
void keccak_inc_init(uint64_t* s_inc);
void keccak_inc_absorb(uint64_t* s_inc, uint32_t r, const uint8_t* m, size_t mlen);
void keccak_inc_finalize(uint64_t* s_inc, uint32_t r, uint8_t p);
void keccak_inc_squeeze(uint8_t* h, size_t outlen, uint64_t* s_inc, uint32_t r);

/* Keccak round constants */
extern const uint64_t KeccakF_RoundConstants[NROUNDS];

#endif // KECCAK_H
