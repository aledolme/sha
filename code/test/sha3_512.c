#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


#include "sha3_512.h"
#include "keccak.h"


/*************************************************
 * Name:        sha3_512
 *
 * Description: SHA3-512 with non-incremental API
 *
 * Arguments:   - uint8_t *output:      pointer to output
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen:   length of input in bytes
 **************************************************/
void sha3_512(uint8_t* output, const uint8_t* input, size_t inlen) {
    uint64_t s[25];
    uint8_t t[SHA3_512_RATE];

    /* Absorb input */
    keccak_absorb(s, SHA3_512_RATE, input, inlen, 0x06);

    /* Squeeze output */
    keccak_squeezeblocks(t, 1, s, SHA3_512_RATE);

    for (size_t i = 0; i < 64; i++) {
        output[i] = t[i];
    }
}

void sha3_512_inc_init(sha3_512incctx* state) {
    state->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_inc_init(state->ctx);
}

void sha3_512_inc_ctx_clone(sha3_512incctx* dest, const sha3_512incctx* src) {
    dest->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKEINCCTX_BYTES);
}

void sha3_512_inc_absorb(sha3_512incctx* state, const uint8_t* input, size_t inlen) {
    keccak_inc_absorb(state->ctx, SHA3_512_RATE, input, inlen);
}

void sha3_512_inc_ctx_release(sha3_512incctx* state) {
    free(state->ctx);
}

void sha3_512_inc_finalize(uint8_t* output, sha3_512incctx* state) {
    uint8_t t[SHA3_512_RATE];
    keccak_inc_finalize(state->ctx, SHA3_512_RATE, 0x06);

    keccak_squeezeblocks(t, 1, state->ctx, SHA3_512_RATE);

    sha3_512_inc_ctx_release(state);

    for (size_t i = 0; i < 64; i++) {
        output[i] = t[i];
    }
}
