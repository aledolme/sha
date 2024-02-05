#ifndef SHAKE128_H
#define  SHAKE128_H

#include <stddef.h>
#include <stdint.h>


#define SHAKE128_RATE 168
#define PQC_SHAKEINCCTX_BYTES (sizeof(uint64_t)*26)
#define PQC_SHAKECTX_BYTES (sizeof(uint64_t)*25)


// Context for incremental API
typedef struct {
    uint64_t* ctx;
} shake128incctx;

// Context for non-incremental API
typedef struct {
    uint64_t* ctx;
} shake128ctx;


/* Initialize the state and absorb the provided input.
 *
 * This function does not support being called multiple times
 * with the same state.
 */
void shake128_absorb(shake128ctx* state, const uint8_t* input, size_t inlen);
/* Squeeze output out of the sponge.
 *
 * Supports being called multiple times
 */
void shake128_squeezeblocks(uint8_t* output, size_t nblocks, shake128ctx* state);
/* Free the state */
void shake128_ctx_release(shake128ctx* state);
/* Copy the state. */
void shake128_ctx_clone(shake128ctx* dest, const shake128ctx* src);

/* Initialize incremental hashing API */
void shake128_inc_init(shake128incctx* state);
/* Absorb more information into the XOF.
 *
 * Can be called multiple times.
 */
void shake128_inc_absorb(shake128incctx* state, const uint8_t* input, size_t inlen);
/* Finalize the XOF for squeezing */
void shake128_inc_finalize(shake128incctx* state);
/* Squeeze output out of the sponge.
 *
 * Supports being called multiple times
 */
void shake128_inc_squeeze(uint8_t* output, size_t outlen, shake128incctx* state);
/* Copy the context of the SHAKE128 XOF */
void shake128_inc_ctx_clone(shake128incctx* dest, const shake128incctx* src);
/* Free the context of the SHAKE128 XOF */
void shake128_inc_ctx_release(shake128incctx* state);

#endif