// lib/helpers/des_helper.dart

import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

class CustomEncryption {
  
  static const String _key = 'mysecret';

  // Basic permutation (for illustration, not actual DES permutation)
  static List<int> _permute(List<int> input, List<int> permutationTable) {
    final List<int> output = List.filled(permutationTable.length, 0);
    for (int i = 0; i < permutationTable.length; i++) {
      output[i] = input[permutationTable[i]];
    }
    return output;
  }

  // XOR two lists of integers (representing bits/bytes)
  static List<int> _xor(List<int> a, List<int> b) {
    if (a.length != b.length) {
      throw ArgumentError('Lists must have the same length for XOR operation.');
    }
    return List.generate(a.length, (i) => a[i] ^ b[i]);
  }

  // Simple Feistel function (highly simplified)
  // In real DES, this is complex with S-boxes, P-boxes, and key mixing.
  static List<int> _feistel(List<int> rightBlock, List<int> roundKey) {
    // For simplicity, let's just XOR the right block with the round key.
    // In real DES, this involves expansion, S-boxes, permutation.
    return _xor(rightBlock, roundKey);
  }

  // Generate a very simple round key from the main key (not DES key schedule)
  static List<int> _generateRoundKey(List<int> mainKey, int round) {
    // A simplistic way to vary the round key
    return mainKey.map((byte) => byte ^ round).toList();
  }

  // --- Encryption and Decryption Functions ---

  static String encrypt(String plainText) {
    final List<int> bytes = utf8.encode(plainText);
    final List<int> keyBytes = utf8.encode(_key);

    // Pad the data to be a multiple of 8 bytes (DES block size)
    final int padding = 8 - (bytes.length % 8);
    final List<int> paddedBytes = List.from(bytes)..addAll(List.filled(padding, padding));

    final List<int> encryptedBytes = [];

    // Process in 8-byte blocks
    for (int i = 0; i < paddedBytes.length; i += 8) {
      List<int> block = paddedBytes.sublist(i, i + 8);

      // Split into left (L0) and right (R0) halves
      List<int> l = block.sublist(0, 4); // First 4 bytes
      List<int> r = block.sublist(4, 8); // Last 4 bytes

      // Perform a few rounds of Feistel cipher (simplified)
      for (int round = 0; round < 3; round++) { 
        List<int> tempR = List.from(r); // Store current R
        List<int> roundKey = _generateRoundKey(keyBytes, round);

        List<int> effectiveRoundKey = List.from(roundKey);
        if (effectiveRoundKey.length > 4) {
          effectiveRoundKey = effectiveRoundKey.sublist(0, 4);
        } else if (effectiveRoundKey.length < 4) {
          effectiveRoundKey.addAll(List.filled(4 - effectiveRoundKey.length, 0));
        }


        r = _xor(l, _feistel(tempR, effectiveRoundKey)); // R_new = L_old XOR f(R_old, K)
        l = tempR; // L_new = R_old
      }

      // Combine L and R 
      encryptedBytes.addAll(r);
      encryptedBytes.addAll(l);
    }

    return base64.encode(encryptedBytes);
  }

  static String decrypt(String encryptedText) {
    final List<int> bytes = base64.decode(encryptedText);
    final List<int> keyBytes = utf8.encode(_key);

    final List<int> decryptedBytes = [];

    // Process in 8-byte blocks
    for (int i = 0; i < bytes.length; i += 8) {
      List<int> block = bytes.sublist(i, i + 8);
      List<int> r = block.sublist(0, 4); 
      List<int> l = block.sublist(4, 8); 

      // Perform decryption rounds (reverse of encryption rounds)
      for (int round = 2; round >= 0; round--) { 
        List<int> tempL = List.from(l); 

        List<int> roundKey = _generateRoundKey(keyBytes, round);
        List<int> effectiveRoundKey = List.from(roundKey);
        if (effectiveRoundKey.length > 4) {
          effectiveRoundKey = effectiveRoundKey.sublist(0, 4);
        } else if (effectiveRoundKey.length < 4) {
          effectiveRoundKey.addAll(List.filled(4 - effectiveRoundKey.length, 0));
        }

        l = _xor(r, _feistel(tempL, effectiveRoundKey)); // L_old = R_old XOR f(L_old, K)
        r = tempL; // R_old = L_old
      }

      // Combine L and R
      decryptedBytes.addAll(l);
      decryptedBytes.addAll(r);
    }

    // Remove padding
    final int padding = decryptedBytes.last;
    if (padding > 0 && padding <= 8) {
      return utf8.decode(decryptedBytes.sublist(0, decryptedBytes.length - padding));
    }
    return utf8.decode(decryptedBytes);
  }
}
