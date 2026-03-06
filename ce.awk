/\.quad/  {
  n = $2;
    system("printf \"\t%s\t%11s  # 0x%016x\n\" '" $1 "' '" $2 "' '" n "'");
  next;
}
/\.long/  { n = $2; if (n < 0) n += 0x100000000; printf "\t%s\t%11s  # 0x%08x\n", $1, $2, n; next }
/\.value/ { n = $2; if (n < 0) n += 0x10000; printf "\t%s\t%11s  # 0x%04x\n", $1, $2, n; next }
/\.byte/  { n = $2; if (n < 0) n += 0x100; printf "\t%s\t%11s  # 0x%02x\n", $1, $2, n; next }
/^#/ { next }
/\<-?[0-9]+\>/  {
  printf "%s", $0;
  patsplit($0, a, /-?\<[0-9]+\>/)
  for (i in a) {
    n = a[i];
    if (n >= 0 && n <= 16) continue
    if (n >= 0 && n <= 0xff) {
      printf " \t# 0x%02x", n
    } else if (n >= 0 && n <= 0xffff) {
      printf " \t# 0x%04x", n
    } else if (n >= 0 && n <= 0xffffffff) {
      printf " \t# 0x%08x", n
    } else if (/\<r[a-z0-9]{2}\>/) {
      system("printf \" \t# 0x%016x\" '" n "'");
    } else {
      if (n < 0) n += 0x100000000
      printf " \t# 0x%08x", n
    }
  }
  printf "\n"
  next
}
/\.intel_syntax/ { next }
/:$/ { print "# ---------------------------------------------" }
{ print }
