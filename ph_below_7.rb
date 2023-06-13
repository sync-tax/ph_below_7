use_debug false
use_bpm 160

#MIXER
master = 1.0

base_amp = 1.0
snare_amp = 0.25
hihat_amp = 0.2

amp_kick = 1.1
bass_volume = 0.1 * amp_kick
amp_ph6 = 0.2

slicer01_amp = 2
beep_amp = 0.5

#----------------------------------------------------------------------
#RHYTHMS
beep_rhythm = (ring 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0,
               0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0)

kick_rhythm = (ring 1, 0, 1, 0)

kick_rhythm2 = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0)
#----------------------------------------------------------------------
#DRUM

with_fx :reverb, mix: 0.5 do
  live_loop :snare3 do
    sample  :sn_dub,
      amp: snare_amp * master,
      rate: (ring, 1.75, 1.8).tick,
      cutoff: 80
    sleep 2
  end
end

with_fx :reverb , mix: 0.25 do
  with_fx :ixi_techno do
    live_loop :hihat do
      sample :drum_cymbal_closed, amp: hihat_amp * master * base_amp, rate: ring(2, 4).tick
      sleep 0.5
    end
  end
end
#----------------------------------------------------------------------
#KICKBASS

live_loop :kick do
  with_fx :eq, low_shelf: 0.2 do
    sleep 0.5
    sample :bd_tek, amp: amp_kick * master * kick_rhythm.tick,
      beat_stretch: 0.8,
      cutoff: 90,
      attack: 0.025,
      release: 0.25
  end
end

live_loop :bass do
  bass_co = range(80, 60, 0.25).mirror
  #stop
  sleep 0.5
  with_fx :eq, low_shelf: 0.25, low_note: 15 do
    with_synth :fm do 
      beep_notes1 = (ring :d2, :e2).tick
      beep_notes2 = (ring :a2, :f2).tick
      play beep_notes1,
        decay: 0.125,
        release: 0.75,
        attack: 0.15,
        sustain: 0.25,
        cutoff: bass_co.look,
        amp: bass_volume * master,
        depth: 0.5
      
    end
  end
  sleep 0.5
end


live_loop :squelch do
  with_fx :flanger, feedback: 0.25 do
    use_random_seed ring(300, 3000, 6000, 2000).tick
    8.times do
      with_synth :tb303 do 
        n = (ring :d1, :e2, :e1).choose
        play n,
          release: 0.5,
          cutoff: rrand(60, 100),
          res: 0.8,
          wave: 0,
          amp: amp_ph6 * master,
          pitch: 8
        sleep 0.5
      end
    end
  end
end

live_loop :slicer01 do
  with_fx :slicer, phase: 0.5 do
    co = (line 80, 130, steps: 16).tick
    sample :ambi_soft_buzz,
      amp: slicer01_amp,
      cutoff: co,
      release: 3,
      attack: 4,
      rate: (ring 1, 2, 3).tick 
    sleep 1
  end
end


live_loop :beep do
  with_fx :reverb, cutoff: 80 do
    sample :elec_blip,
      attack: 0.1,
      cutoff: rrand(80, 100),
      amp: beep_amp * beep_rhythm.tick * master
  end
  sleep 0.5
end
