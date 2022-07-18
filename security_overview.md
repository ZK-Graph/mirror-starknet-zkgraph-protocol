*Zero Knowledge Proofs (ZPKs)*

Zero Knowledge Proofs allow someone to verify that some computation is correct without having to do the computations. The technique involves recognising that a computation is really a mathematical function. To perform computation on some data is the same as performing a mathematical function f(x) on that data. A set of checks can be created that can be given to another person who can very quickly check them and be convinced that the computation was correct.

*STARKs*

STARKs (Scalable Transparent ARguments of Knowledge) are a subset of ZKPs. They are novel firstly for their absence of a trusted setup and secondly for their resistance to quantum computers. Both of these features arise from the construction being created from hashing and data sampling, rather than on elliptic curves and the private knowledge of some exponent. STARKs are succinct meaning that verification of a proof is much quicker than the original computation.

*Privacy*

The inputs to a given Cairo program are required to generate a proof. The prover therefore has knowledge of this information. In the current deployment, this prover is operated by Starkware.

Privacy can be enabled within the protocol by introducing a proof-generation step on the user-side of Cairo. Such a proof would attest to the value of the private inputs. This proof would then be passed, along with the usual Cairo program trace to the prover (either the Starkware proving service, or an independent Starknet prover) who would construct the proof using those components.

*References:* 

1. https://github.com/perama-v/perama-v.github.io/blob/main/docs/cairo/technical_summary.md 

2. https://medium.com/starkware/arithmetization-i-15c046390862

3. https://medium.com/starkware/arithmetization-ii-403c3b3f4355 

4. https://medium.com/starkware/a-framework-for-efficient-starks-19608ba06fbe

5. https://vitalik.ca/general/2022/06/15/using_snarks.html

6. Stani talking about adding ZK Proofs to create private profiles: https://youtu.be/_0F4QP5rJ_Q?t=3186
