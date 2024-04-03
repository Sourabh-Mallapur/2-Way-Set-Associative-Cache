# 2-Way-Set-Associative-Cache
This repository contains design and implemention of a two-set associative cache using Verilog. 

## Methodology 
1. Understanding Cache Architecture: studied the basic concepts of cache memory, including its organization, operation, and the benefits it provides in enhancing memory access speed. 
2. Two-Set Associative Cache Design: conceptualized the design of a two-set associative cache, which involves dividing the cache into two sets, each containing multiple cache lines. This allows for a more efficient use of cache memory compared to direct-mapped caches and lesser comparisons compared to fully associative cache. 
3. Verilog Implementation: translated our design into hardware description language, defining the cache structure, data paths, and control logic. 
4. Simulation and Testing: simulated the design using suitable test cases to verify its functionality and performance.

## Theory
Cache memory serves as a high-speed buffer between the CPU and main memory, storing frequently accessed data and instructions to reduce the average time taken to access memory. In a two-set associative cache, the cache is divided into two sets, and each memory block can be mapped to one of the lines in either set. This allows for more flexibility compared to direct-mapped caches, as each memory block can potentially be stored in one of two locations within the cache. 

If we consider a main memory of size 256 B with block size of 1 Byte, paired with a cache having 32 lines, and consider 2 way associative cache. 
- 256 Bytes = 2^8 Bytes so 8 bit Address 
- Cache with 32 Lines and 2 Way associativity 
- 32/2 = 16 Sets => 4 bits for Set/Index Addressing 
- Block Size = 1Byte => So No bits for Byte Addressing 
- Tag bits = 8 – 4 = 4 Bits => 16 Pages

![CA drawio](https://github.com/Sourabh-Mallapur/2-Way-Set-Associative-Cache/assets/106715050/2853e82a-8dfc-48b9-b96f-c322760e1c4f)

The cache access process involves the following steps: 

1. Cache Lookup: The CPU issues a memory access request, specifying the memory address it wants to read from or write to. 
2. Indexing: The memory address is divided into different fields, including the tag, index, and offset. The index field determines which set in the cache the memory block belongs to. 
3. Tag Comparison: The tag associated with the memory address is compared with the tags stored in the cache lines within the selected set to check for a cache hit. 
4. Data Retrieval: If a cache hit occurs, the required data is retrieved from the cache. Otherwise, a cache miss occurs, and the data must be fetched from main memory and stored in the cache for future access. 
5. LRU Updation: After Reading a way, a pointer stores the least recently used way, this is useful in implementing a LRU cache replacement policy. Two-set associative caches offer a balance between the simplicity of direct-mapped caches and the flexibility of fully associative caches, providing improved performance for certain memory access patterns. 

## Results
Upon simulation and testing of our Verilog implementation, we obtained the following 
![compile](https://github.com/Sourabh-Mallapur/2-Way-Set-Associative-Cache/assets/106715050/f5faee6d-0277-4a76-bbdd-e487e15809c0)

Simulation Waveform	
![sim](https://github.com/Sourabh-Mallapur/2-Way-Set-Associative-Cache/assets/106715050/06b5ac0b-fa56-4ecf-9d18-f95775627cb5)

