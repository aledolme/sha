#ifndef SHA3_256_H
#define  SHA3_256_H

#include <stddef.h>
#include <stdint.h>

#define SHA3_256_RATE 136

#define PQC_SHAKEINCCTX_BYTES (sizeof(uint64_t)*26)
#define PQC_SHAKECTX_BYTES (sizeof(uint64_t)*25)

// Context for incremental API
typedef struct {
    uint64_t* ctx;
} sha3_256incctx;

/* Initialize the incremental hashing state */
void sha3_256_inc_init(sha3_256incctx* state);
/* Absorb blocks into SHA3 */
void sha3_256_inc_absorb(sha3_256incctx* state, const uint8_t* input, size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_256_inc_finalize(uint8_t* output, sha3_256incctx* state);
/* Copy the context */
void sha3_256_inc_ctx_clone(sha3_256incctx* dest, const sha3_256incctx* src);
/* Release the state, don't use if `_finalize` has been used */
void sha3_256_inc_ctx_release(sha3_256incctx* state);

void sha3_256(uint8_t* output, const uint8_t* input, size_t inlen);
#endif
