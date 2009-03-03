#!/usr/bin/perl -w

#use utf8;



while (<>) 
{

    s/'/"/g ; # stress mark to "
s/ː/:/g ;     # length
s/ʦ/ts/g ;     #voiceless alveolar affricate
s/ʣ/dz/g ;     #voiced alveolar affricate
s/ʧ/tS/g ;     #voiceless postalveolar affricate
s/ʤ/dZ/g ;     #voiced postalveolar affricate
s/c/c/g ;     #voiceless palatal stop
s/ɟ/J\\/g ;     #(overstroked j) voiced palatal stop
s/k/k/g ;     #voiceless velar stop
s/g/g/g ;     #voiced velar stop
s/q/q/g ;     #voiceless uvular stop
s/ɸ/p\\/g ;     #(Greek phi) voiceless bilabial fricative
s/β/B/g ;     #(Greek beta) voiced bilabial fricative
s/f/f/g ;     #voiceless labiodental fricative
s/v/v/g ;     #voiced labiodental fricative
s/θ/T/g ;     #(Greek theta) voiceless dental fricative
s/ð/D/g ;     #(Icelandic eth) voiced dental fricative
s/s/s/g ;     #voiceless alveolar fricative
s/z/z/g ;     #voiced alveolar fricative
s/ʃ/S/g ;     #voiceless postalveolar fricative
s/ʒ/Z/g ;     #voiced postalveolar fricative
s/ç/C/g ;     #(cedilla) voiceless palatal fricative
s/ʝ/j\\/g ;     #(j with crossed tail) voiced palatal fricative
s/x/x/g ;     #voiceless velar fricative
s/γ/G/g ;     #(Greek gamma) voiced velar fricative
s/ħ/X\\/g ;     #(overstroked h) voiceless pharyngeal fricative
s/ʕ/?\\/g ;     #(Inverted ?) voiced pharyngeal fricative
s/h/h/g ;     #voiceless glottal approximant
s/ɦ/h\\/g ;     #(h with upper tail to the right) voiced glottal approximant
s/m/m/g ;     #bilabial nasal
s/ɱ/F/g ;     #(m with downward right tail) labiodental nasal
s/n/n/g ;     #alveolar or dental nasal
s/ɲ/J/g ;     #(n with downward left tail) palatal nasal
s/ŋ/N/g ;     #(n with downward right tail) velar nasal
s/l/l/g ;     #alveolar lateral
s/ʎ/L/g ;     #turned down y, alt. λ (Greek lambda) palatal lateral
s/ɫ/5/g ;     #(l with middle tilde) velarized dental lateral
s/ł/XXX/g ;    # Unvoiced l. Sampa?
s/ɾ/4/g ;     #(r without upper-left serif) alveolar flap
s/r/r/g ;     #alveolar trill
s/ɹ/r\\/g ;     #(r rotated 180°) retroflexed alveolar approximant
s/ʀ/R/g ;     #(small capital R) uvular trill
s/ʋ/P/g ;     #labiodental approximant
s/w/w/g ;     #velo-labial approximant
s/ɥ/H/g ;     #(turned down h) palato-labial approximant
s/j/j/g ;     #palatal approximant
s/ʈ	/t`/g ;     #0288, 648 (` = ASCII 096)
s/ɖ/d`/g ;     #0256, 598
s/ɱ/F/g ;     #0271, 625
s/ɳ/n`/g ;     #0273, 627
s/ɲ/J/g ;     #0272, 626
s/ŋ/N/g ;     #014B, 331
s/ɴ/N\\/g ;     #0274, 628
s/ʙ/B\\/g ;     #0299, 665
s/ʀ/R\\/g ;     #0280, 640
s/ɾ/4/g ;     #027E, 638
s/ɽ/r`/g ;     #027D, 637
s/ɸ/p\\/g ;     #0278, 632
s/β/B/g ;     #03B2, 946
s/θ/T/g ;     #03B8, 952
s/ð/D/g ;     #00F0, 240
s/ʃ/S/g ;     #0283, 643
s/ʒ/Z/g ;     #0292, 658
s/ʂ/s`/g ;     #0282, 642
s/ʐ/z`/g ;     #0290, 656
s/ç/C/g ;     #00E7, 231
s/ʝ/j\\/g ;     #029D, 669
s/ɣ/G/g ;     #0263, 611
s/χ/X/g ;     #03C7, 967
s/ʁ/R/g ;     #0281, 641
s/ħ/X\\/g ;     #0127, 295
s/ʕ/?\\/g ;     #0295, 661
s/ɦ/h\\/g ;     #0266, 614
s/ɯ/M/g ;     #
s/ɨ/1/g ;     #
s/ʉ/}/g ;     #
s/ɪ/I/g ;     #
s/ʏ/Y/g ;     #
s/ʊ/U/g ;     #
s/ø/2/g ;     #
s/ɘ/@\\/g ;     #
s/ɵ/8/g ;     #
s/ɤ/7/g ;     #
s/ə/@/g ;     #
s/ɛ/E/g ;     #
s/œ/9/g ;     #
s/ɜ/3/g ;     #
s/ɞ/3\\/g ;     #
s/ʌ/V/g ;     #
s/ɔ/O/g ;     #
s/æ/{/g ;     #
s/ɐ/6/g ;     #
s/ɶ/&/g ;     #
s/ɑ/A/g ;     #
s/ɒ/Q/g ;     #
s/̆/_X/g ;     # breve, extra short 
s/̥/_0/g ;     # Voiceless


print ;
}

