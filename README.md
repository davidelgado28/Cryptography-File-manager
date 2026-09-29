# FileCrypto CLI 

A command-line utility (CLI) developed in **Free Pascal**, focused on demonstrating pure data structures (Records and dynamic Linked Lists using pointers) and byte-level encryption operations (XOR).

## Features

- **In-Memory Metadata Management:** Dynamic storage of file information (Name, Size, and Extension) using pointers and heap allocation.
- **Dynamic Linked List:** Manual implementation of node (`TFileNode`) insertion, listing, and deallocation to prevent memory leaks.
- **Symmetric XOR Encryption:** Byte-by-byte binary reading and writing applying a reversible XOR mask; suitable for text or binary files.

---

## Prerequisites

To compile and run this program, you only need the standard Free Pascal compiler (**FPC**):

- [Free Pascal Compiler (FPC)](https://www.freepascal.org/)
