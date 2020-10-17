\version "2.18.2"
\paper {
  #(set-paper-size "letter")
  ragged-last-bottom = ##f
}
\header {
  title = "Spanish Castle Magic"
  tagline = #(string-append "Score created using DrumBurp 1.1.2, engraved with Lilypond " (lilypond-version))
  composer = "Jimi Hendrix"
  arranger = "Dave B"
}
\layout {
  #(layout-set-staff-size 20)
}

#(define (rest-score r)
  (let ((score 0)
    (yoff (ly:grob-property-data r 'Y-offset))
    (sp (ly:grob-property-data r 'staff-position)))
    (if (number? yoff)
    (set! score (+ score 2))
    (if (eq? yoff 'calculation-in-progress)
        (set! score (- score 3))))
    (and (number? sp)
     (<= 0 2 sp)
     (set! score (+ score 2))
     (set! score (- score (abs (- 1 sp)))))
    score))

#(define (merge-rests-on-positioning grob)
  (let* ((can-merge #f)
     (elts (ly:grob-object grob 'elements))
     (num-elts (and (ly:grob-array? elts)
            (ly:grob-array-length elts)))
     (two-voice? (= num-elts 2)))
    (if two-voice?
    (let* ((v1-grob (ly:grob-array-ref elts 0))
           (v2-grob (ly:grob-array-ref elts 1))
           (v1-rest (ly:grob-object v1-grob 'rest))
           (v2-rest (ly:grob-object v2-grob 'rest)))
      (and
       (ly:grob? v1-rest)
       (ly:grob? v2-rest)
       (let* ((v1-duration-log (ly:grob-property v1-rest 'duration-log))
          (v2-duration-log (ly:grob-property v2-rest 'duration-log))
          (v1-dot (ly:grob-object v1-rest 'dot))
          (v2-dot (ly:grob-object v2-rest 'dot))
          (v1-dot-count (and (ly:grob? v1-dot)
                     (ly:grob-property v1-dot 'dot-count -1)))
          (v2-dot-count (and (ly:grob? v2-dot)
                     (ly:grob-property v2-dot 'dot-count -1))))
         (set! can-merge
           (and
            (number? v1-duration-log)
            (number? v2-duration-log)
            (= v1-duration-log v2-duration-log)
            (eq? v1-dot-count v2-dot-count)))
         (if can-merge
         ;; keep the rest that looks best:
         (let* ((keep-v1? (>= (rest-score v1-rest)
                      (rest-score v2-rest)))
            (rest-to-keep (if keep-v1? v1-rest v2-rest))
            (dot-to-kill (if keep-v1? v2-dot v1-dot)))
           ;; uncomment if you're curious of which rest was chosen:
           ;;(ly:grob-set-property! v1-rest 'color green)
           ;;(ly:grob-set-property! v2-rest 'color blue)
           (ly:grob-suicide! (if keep-v1? v2-rest v1-rest))
           (if (ly:grob? dot-to-kill)
               (ly:grob-suicide! dot-to-kill))
           (ly:grob-set-property! rest-to-keep 'direction 0)
           (ly:rest::y-offset-callback rest-to-keep)))))))
    (if can-merge
    #t
    (ly:rest-collision::calc-positioning-done grob))))

    makePercent =
    #(define-music-function (parser location note) (ly:music?)
       "Make a percent repeat the same length as NOTE."
       (make-music 'PercentEvent
                   'length (ly:music-length note)))

    swing_eight = \mark \markup {
      \line \general-align #Y #DOWN { \score {
      \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        b'8[ b8]
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
        \Staff \remove "Clef_engraver"
        \remove "Time_signature_engraver" }
      }} " ="
      \score { \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        \times 2/3 { b'8[ r b8] }
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
          \Staff
          \remove "Clef_engraver"
          \remove "Time_signature_engraver" }
        }}
      \fontsize #-2
      \italic { "  swing" }
      }
    }

    swing_sixteen = \mark \markup {
      \line \general-align #Y #DOWN { \score {
      \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        b'16[ b16]
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
        \Staff \remove "Clef_engraver"
        \remove "Time_signature_engraver" }
      }} " ="
      \score { \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        \times 2/3 { b'16[ r b16] }
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
          \Staff
          \remove "Clef_engraver"
          \remove "Time_signature_engraver" }
        }}
      \fontsize #-2
      \italic { "  swing" }
      }
    }

    swing_thirtytwo = \mark \markup {
      \line \general-align #Y #DOWN { \score {
      \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        b'32[ b32]
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
        \Staff \remove "Clef_engraver"
        \remove "Time_signature_engraver" }
      }} " ="
      \score { \new Staff \with {
        fontSize = #-2
        \override StaffSymbol #'line-count = #0
        \override VerticalAxisGroup #'Y-extent = #'(0 . 0)
      }
      \relative {
        \stemUp
        \override Score.SpacingSpanner
          #'common-shortest-duration = #(ly:make-moment 3 16)
        \override Beam #'positions = #'(2.5 . 2.5)
        \times 2/3 { b'32[ r b32] }
      }
      \layout {
        ragged-right= ##t
        indent = 0
        \context {
          \Staff
          \remove "Clef_engraver"
          \remove "Time_signature_engraver" }
        }}
      \fontsize #-2
      \italic { "  swing" }
      }
    }
drumPitchNames = #'(   (footpedal . footpedal)
   (kick . kick)
   (kicka . kicka)
   (kickb . kickb)
   (kickc . kickc)
   (floortom . floortom)
   (floortoma . floortoma)
   (floortomb . floortomb)
   (floortomc . floortomc)
   (floortomd . floortomd)
   (snare . snare)
   (snarea . snarea)
   (snareb . snareb)
   (snarec . snarec)
   (snared . snared)
   (snaree . snaree)
   (midtom . midtom)
   (midtoma . midtoma)
   (midtomb . midtomb)
   (midtomc . midtomc)
   (midtomd . midtomd)
   (hightom . hightom)
   (hightoma . hightoma)
   (hightomb . hightomb)
   (hightomc . hightomc)
   (hightomd . hightomd)
   (ride . ride)
   (ridea . ridea)
   (rideb . rideb)
   (ridec . ridec)
   (hihat . hihat)
   (hihata . hihata)
   (hihatb . hihatb)
   (hihatc . hihatc)
   (hihatd . hihatd)
   (hihate . hihate)
   (hihatf . hihatf)
   (crash . crash)
   (crasha . crasha)
   (crashb . crashb)
   (hf . footpedal)
   (bd . kick)
   (bda . kicka)
   (bdb . kickb)
   (bdc . kickc)
   (ft . floortom)
   (fta . floortoma)
   (ftb . floortomb)
   (ftc . floortomc)
   (ftd . floortomd)
   (sn . snare)
   (sna . snarea)
   (snb . snareb)
   (snc . snarec)
   (snd . snared)
   (sne . snaree)
   (mt . midtom)
   (mta . midtoma)
   (mtb . midtomb)
   (mtc . midtomc)
   (mtd . midtomd)
   (ht . hightom)
   (hta . hightoma)
   (htb . hightomb)
   (htc . hightomc)
   (htd . hightomd)
   (ri . ride)
   (ria . ridea)
   (rib . rideb)
   (ric . ridec)
   (hh . hihat)
   (hha . hihata)
   (hhb . hihatb)
   (hhc . hihatc)
   (hhd . hihatd)
   (hhe . hihate)
   (hhf . hihatf)
   (cr . crash)
   (cra . crasha)
   (crb . crashb)
)

#(define dbdrums '(
   (footpedal cross #f -5)
   (kick () #f -3)
   (kicka () #f -3)
   (kickb () #f -3)
   (kickc () #f -3)
   (floortom () #f -1)
   (floortoma () #f -1)
   (floortomb () #f -1)
   (floortomc () #f -1)
   (floortomd () #f -1)
   (snare () #f 1)
   (snarea () #f 1)
   (snareb () #f 1)
   (snarec cross #f 1)
   (snared () #f 1)
   (snaree () #f 1)
   (midtom () #f 2)
   (midtoma () #f 2)
   (midtomb () #f 2)
   (midtomc () #f 2)
   (midtomd () #f 2)
   (hightom () #f 3)
   (hightoma () #f 3)
   (hightomb () #f 3)
   (hightomc () #f 3)
   (hightomd () #f 3)
   (ride cross #f 4)
   (ridea cross #f 4)
   (rideb triangle #f 4)
   (ridec cross #f 4)
   (hihat cross #f 5)
   (hihata cross #f 5)
   (hihatb cross "open" 5)
   (hihatc cross #f 5)
   (hihatd cross #f 5)
   (hihate cross "stopped" 5)
   (hihatf cross #f 5)
   (crash cross #f 6)
   (crasha cross #f 6)
   (crashb cross "stopped" 6)
))

\score {
  \new DrumStaff = "main" <<
    \set DrumStaff.drumStyleTable = #(alist->hash-table dbdrums)
    \set Staff.instrumentName = #"Drums"
    \tempo 4 = 98
    \override Score.RehearsalMark #'self-alignment-X = #LEFT
    \override Score.TimeSignature.break-visibility = #end-of-line-invisible
    \drummode {
      \time 4/4
      <<
        \new DrumVoice {
          r2. r8. bd16
        }
      >>
      <<
        \new DrumVoice {
          \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd16 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          cr4 ri8 ri8 ri4 r8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd4 sna8.\accent sn16 bd8 bd8 r16 bd16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 r8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd4 sna8.\accent sn16 bd8 bd8 r16 bd16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd4 sna8.\accent sn16 bd8 bd8 r16 bd16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 s4
        }
        \new DrumVoice {
          \voiceTwo
          bd4 sna8.\accent sn16 bd8 bd8 sn32 sn32 sn32 sn32 sna16\accent bd16
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd8 bd8 bd8 bd8 bd8
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 <\parenthesize bdb>8 sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 <\parenthesize bdb>8
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd8 bd8 bd8 bd8 bd8
        }
      >>
      <<
        \new DrumVoice {
          <bd sn>16 sn16 <\parenthesize bdb sn>8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length <bd snd>8 bd8 bd8 bd8 bd8 bd8
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd8 bd8 bd8 bd8 bd8
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 <\parenthesize bdb>8 sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd4
        }
      >>
      <<
        \new DrumVoice {
          sn16 sn16 sn8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length snd8 bd8 bd8 bd8 bd8 bd8
        }
      >>
      <<
        \new DrumVoice {
          <bd sn>16 <\parenthesize bdb sn>16 <bd sn>8 \override Stem #'length = #4 \acciaccatura{snd8} \revert Stem #'length <bd snd>8 bd8 bd8 bd8 mt32 sn32 sn32 sn32 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          cr8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd8. <\parenthesize bdb>16 sna8.\accent sn16 bd8 bd8 r16 bd16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd16 sn16 bd16 bd16 sna8.\accent sn16 bd8 bd8 <\parenthesize bdb>8 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd8. <\parenthesize bdb>16 sna8.\accent sn16 bd8 bd8 <\parenthesize bdb>8 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 cr8 s4
        }
        \new DrumVoice {
          \voiceTwo
          bd8. <\parenthesize bdb>16 sna8.\accent sn16 bd16 bd16 sna8\accent mt32 sn32 sn32 sn32 sna32\accent sn32 <\parenthesize snb>32 sn32
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          cr8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd8. <\parenthesize bdb>16 sna8.\accent sn16 bd16 <\parenthesize bdb>16 bd8 bd16 <\parenthesize bdb>16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd16 sn16 bd16 bd16 sna8\accent bd16 sn16 bd16 bd16 sn8 sna16\accent bd16 sna8\accent
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          cr8 ri8 ri8 ri8 ri8 ri8 ri8 ri8
        }
        \new DrumVoice {
          \voiceTwo
          bd8. <\parenthesize bdb>16 sna8.\accent sn16 bd8 bd8 bd16 bd16 sna16\accent bd16
        }
      >>
      <<
        \new DrumVoice {
          \voiceOne
          ri8 ri8 ri8 ri8 ri8 ri8 s4
        }
        \new DrumVoice {
          \voiceTwo
          bd16 sn16 bd16 bd16 sna8.\accent sn16 bd16 bd16 sn8 mt32 sn32 sn32 sn32 sna8\accent
        }
      >>
    }
  >>
  \layout {
    \context {
      \DrumStaff \override RestCollision #'positioning-done = #merge-rests-on-positioning
    }
  }
}
