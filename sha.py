import hashlib

def perform_sha3_primitive(data, primitive):
    if primitive == "sha3-224":
        hash_func = hashlib.sha3_224()
    elif primitive == "sha3-256":
        hash_func = hashlib.sha3_256()
    elif primitive == "sha3-384":
        hash_func = hashlib.sha3_384()
    elif primitive == "sha3-512":
        hash_func = hashlib.sha3_512()
    else:
        raise ValueError("Invalid primitive specified")

    rate = hash_func.block_size * 2  # Block size in hexadecimal characters
    data_len = len(data)

    for i in range(0, data_len, rate):
        block = data[i:i + rate]
        hash_func.update(bytes.fromhex(block))

    return hash_func.hexdigest()

if __name__ == "__main__":
    input_data = input("Enter the input hexadecimal values: ")
    primitive = input("Enter the desired primitive (sha3-224, sha3-256, sha3-384, sha3-512): ")

    try:
        result = perform_sha3_primitive(input_data, primitive)
        print(f"{primitive} hash of the input: {result}")
    except ValueError as e:
        print(e)
