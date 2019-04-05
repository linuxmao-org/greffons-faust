declare name "LinuxMAO Flangeur Stéréo";
declare author "linuxmao.org";
declare version "1.0";
declare license "CC0-1.0";

import("stdfaust.lib");

process(sg, sd) = flanger(sg, 0), flanger(sd, ph) with {
  ph = hslider("[5]Déphasage stéréo [unit:deg]", 90, 0, 360, 1) : *(ma.PI/180) : si.smooth(0.999);
};

flanger(in, phase) = dry*in + wet*out with {
  delaimax = 0.002;

  fr = hslider("[1]Fréquence LFO [unit:Hz]", 0.3, 0.1, 1.0, 0.01);
  pd = hslider("[2]Profondeur délai [unit:ms]", 1, 0, delaimax*1000, 0.01) : /(1000) : si.smooth(0.999);
  wet = hslider("[3]Gain traitement [unit:dB]", -6, -60, +10, 0.1) : ba.db2linear : si.smooth(0.999);
  dry = hslider("[4]Gain direct [unit:dB]", -12, -60, +10, 0.1) : ba.db2linear : si.smooth(0.999);

  att_globale = ba.db2linear(-6);
  fb = ba.db2linear(-3);
  ff = ba.db2linear(-3);
  bl = ba.db2linear(-3);

  out = (peigne_ff(in) * bl + peigne_fb(in) * ff) * att_globale;
  delaimod = pd * ((os.oscp(fr, phase)+1)/2);
  ligne = de.fdelay(int(ceil(delaimax*192000)), delaimod*ma.SR);
  peigne_fb = (+ : ligne) ~ *(fb);
  peigne_ff = _ <: (_,peigne_fb) :> + : *(ff);
};
