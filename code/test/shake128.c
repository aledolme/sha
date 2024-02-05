#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "shake128.h"
#include "keccak.h"


void shake128_inc_init(shake128incctx* state) {
    state->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_inc_init(state->ctx);
}

void shake128_inc_absorb(shake128incctx* state, const uint8_t* input, size_t inlen) {
    keccak_inc_absorb(state->ctx, SHAKE128_RATE, input, inlen);
}

void shake128_inc_finalize(shake128incctx* state) {
    keccak_inc_finalize(state->ctx, SHAKE128_RATE, 0x1F);
}

void shake128_inc_squeeze(uint8_t* output, size_t outlen, shake128incctx* state) {
    keccak_inc_squeeze(output, outlen, state->ctx, SHAKE128_RATE);
}

void shake128_inc_ctx_clone(shake128incctx* dest, const shake128incctx* src) {
    dest->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKEINCCTX_BYTES);
}

void shake128_inc_ctx_release(shake128incctx* state) {
    free(state->ctx);
}

/*************************************************
 * Name:        shake128_absorb
 *
 * Description: Absorb step of the SHAKE128 XOF.
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
 *              - const uint8_t *input: pointer to input to be absorbed
 *                                            into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake128_absorb(shake128ctx* state, const uint8_t* input, size_t inlen) {
    state->ctx = malloc(PQC_SHAKECTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_absorb(state->ctx, SHAKE128_RATE, input, inlen, 0x1F);
}

/*************************************************
 * Name:        shake128_squeezeblocks
 *
 * Description: Squeeze step of SHAKE128 XOF. Squeezes full blocks of
 *              SHAKE128_RATE bytes each. Modifies the state. Can be called
 *              multiple times to keep squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *output: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed
 *                                            (written to output)
 *              - shake128ctx *state: pointer to input/output Keccak state
 **************************************************/
void shake128_squeezeblocks(uint8_t* output, size_t nblocks, shake128ctx* state) {
    keccak_squeezeblocks(output, nblocks, state->ctx, SHAKE128_RATE);
}

void shake128_ctx_clone(shake128ctx* dest, const shake128ctx* src) {
    dest->ctx = malloc(PQC_SHAKECTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKECTX_BYTES);
}

/** Release the allocated state. Call only once. */
void shake128_ctx_release(shake128ctx* state) {
    free(state->ctx);
}

/*************************************************
 * Name:        shake128
 *
 * Description: SHAKE128 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *output: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake128(uint8_t* output, size_t outlen,
    const uint8_t* input, size_t inlen) {
    size_t nblocks = outlen / SHAKE128_RATE;
    uint8_t t[SHAKE128_RATE];
    shake128ctx s;

    shake128_absorb(&s, input, inlen);
    shake128_squeezeblocks(output, nblocks, &s);

    output += nblocks * SHAKE128_RATE;
    outlen -= nblocks * SHAKE128_RATE;

    if (outlen) {
        shake128_squeezeblocks(t, 1, &s);
        for (size_t i = 0; i < outlen; ++i) {
            output[i] = t[i];
        }
    }
    shake128_ctx_release(&s);
}