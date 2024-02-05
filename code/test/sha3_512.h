#ifndef SHA3_512_H
#define  SHA3_512_H

#include <stddef.h>
#include <stdint.h>

#define SHA3_512_RATE 72

#define PQC_SHAKEINCCTX_BYTES (sizeof(uint64_t)*26)
#define PQC_SHAKECTX_BYTES (sizeof(uint64_t)*25)

// Context for incremental API
typedef struct {
    uint64_t* ctx;
} sha3_512incctx;


/* Initialize the incremental hashing state */
void sha3_512_inc_init(sha3_512incctx* state);
/* Absorb blocks into SHA3 */
void sha3_512_inc_absorb(sha3_512incctx* state, const uint8_t* input, size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_512_inc_finalize(uint8_t* output, sha3_512incctx* state);
/* Copy the context */
void sha3_512_inc_ctx_clone(sha3_512incctx* dest, const sha3_512incctx* src);
/* Release the state, don't use if `_finalize` has been used */
void sha3_512_inc_ctx_release(sha3_512incctx* state);

/* One-stop SHA3-512 shop */
void sha3_512(uint8_t* output, const uint8_t* input, size_t inlen);

#endif
