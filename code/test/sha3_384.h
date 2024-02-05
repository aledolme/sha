#ifndef SHA3_384_H
#define  SHA3_384_H

#include <stddef.h>
#include <stdint.h>

#define SHA3_384_RATE 104

#define PQC_SHAKEINCCTX_BYTES (sizeof(uint64_t)*26)
#define PQC_SHAKECTX_BYTES (sizeof(uint64_t)*25)


// Context for incremental API
typedef struct {
    uint64_t* ctx;
} sha3_384incctx;


/* Initialize the incremental hashing state */
void sha3_384_inc_init(sha3_384incctx* state);
/* Absorb blocks into SHA3 */
void sha3_384_inc_absorb(sha3_384incctx* state, const uint8_t* input, size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_384_inc_finalize(uint8_t* output, sha3_384incctx* state);
/* Copy the context */
void sha3_384_inc_ctx_clone(sha3_384incctx* dest, const sha3_384incctx* src);
/* Release the state, don't use if `_finalize` has been used */
void sha3_384_inc_ctx_release(sha3_384incctx* state);

/* One-stop SHA3-384 shop */
void sha3_384(uint8_t* output, const uint8_t* input, size_t inlen);


#endif
