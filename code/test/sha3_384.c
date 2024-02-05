#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


#include "sha3_384.h"
#include "keccak.h"



/*************************************************
 * Name:        sha3_384
 *
 * Description: SHA3-256 with non-incremental API
 *
 * Arguments:   - uint8_t *output:      pointer to output
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen:   length of input in bytes
 **************************************************/
void sha3_384(uint8_t* output, const uint8_t* input, size_t inlen) {
    uint64_t s[25];
    uint8_t t[SHA3_384_RATE];

    /* Absorb input */
    keccak_absorb(s, SHA3_384_RATE, input, inlen, 0x06);

    /* Squeeze output */
    keccak_squeezeblocks(t, 1, s, SHA3_384_RATE);

    for (size_t i = 0; i < 48; i++) {
        output[i] = t[i];
    }
}



void sha3_384_inc_ctx_clone(sha3_384incctx* dest, const sha3_384incctx* src) {
    dest->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKEINCCTX_BYTES);
}

void sha3_384_inc_absorb(sha3_384incctx* state, const uint8_t* input, size_t inlen) {
    keccak_inc_absorb(state->ctx, SHA3_384_RATE, input, inlen);
}

void sha3_384_inc_ctx_release(sha3_384incctx* state) {
    free(state->ctx);
}

void sha3_384_inc_finalize(uint8_t* output, sha3_384incctx* state) {
    uint8_t t[SHA3_384_RATE];
    keccak_inc_finalize(state->ctx, SHA3_384_RATE, 0x06);

    keccak_squeezeblocks(t, 1, state->ctx, SHA3_384_RATE);

    sha3_384_inc_ctx_release(state);

    for (size_t i = 0; i < 48; i++) {
        output[i] = t[i];
    }
}



void sha3_384_inc_init(sha3_384incctx* state) {
    state->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_inc_init(state->ctx);
}

