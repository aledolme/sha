#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


#include "shake256.h"
#include "keccak.h"


void shake256_inc_init(shake256incctx* state) {
    state->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_inc_init(state->ctx);
}

void shake256_inc_absorb(shake256incctx* state, const uint8_t* input, size_t inlen) {
    keccak_inc_absorb(state->ctx, SHAKE256_RATE, input, inlen);
}

void shake256_inc_finalize(shake256incctx* state) {
    keccak_inc_finalize(state->ctx, SHAKE256_RATE, 0x1F);
}

void shake256_inc_squeeze(uint8_t* output, size_t outlen, shake256incctx* state) {
    keccak_inc_squeeze(output, outlen, state->ctx, SHAKE256_RATE);
}

void shake256_inc_ctx_clone(shake256incctx* dest, const shake256incctx* src) {
    dest->ctx = malloc(PQC_SHAKEINCCTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKEINCCTX_BYTES);
}

void shake256_inc_ctx_release(shake256incctx* state) {
    free(state->ctx);
}



/*************************************************
 * Name:        shake256_absorb
 *
 * Description: Absorb step of the SHAKE256 XOF.
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - shake256ctx *state: pointer to (uninitialized) output Keccak state
 *              - const uint8_t *input: pointer to input to be absorbed
 *                                            into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256_absorb(shake256ctx* state, const uint8_t* input, size_t inlen) {
    state->ctx = malloc(PQC_SHAKECTX_BYTES);
    if (state->ctx == NULL) {
        exit(111);
    }
    keccak_absorb(state->ctx, SHAKE256_RATE, input, inlen, 0x1F);
}

/*************************************************
 * Name:        shake256_squeezeblocks
 *
 * Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
 *              SHAKE256_RATE bytes each. Modifies the state. Can be called
 *              multiple times to keep squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *output: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed
 *                                (written to output)
 *              - shake256ctx *state: pointer to input/output Keccak state
 **************************************************/
void shake256_squeezeblocks(uint8_t* output, size_t nblocks, shake256ctx* state) {
    keccak_squeezeblocks(output, nblocks, state->ctx, SHAKE256_RATE);
}

void shake256_ctx_clone(shake256ctx* dest, const shake256ctx* src) {
    dest->ctx = malloc(PQC_SHAKECTX_BYTES);
    if (dest->ctx == NULL) {
        exit(111);
    }
    memcpy(dest->ctx, src->ctx, PQC_SHAKECTX_BYTES);
}

/** Release the allocated state. Call only once. */
void shake256_ctx_release(shake256ctx* state) {
    free(state->ctx);
}

/*************************************************
 * Name:        shake256
 *
 * Description: SHAKE256 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *output: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256(uint8_t* output, size_t outlen,
    const uint8_t* input, size_t inlen) {
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[SHAKE256_RATE];
    shake256ctx s;

    shake256_absorb(&s, input, inlen);
    shake256_squeezeblocks(output, nblocks, &s);

    output += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;

    if (outlen) {
        shake256_squeezeblocks(t, 1, &s);
        for (size_t i = 0; i < outlen; ++i) {
            output[i] = t[i];
        }
    }
    shake256_ctx_release(&s);
}




