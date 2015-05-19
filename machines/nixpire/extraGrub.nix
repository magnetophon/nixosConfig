''
menuentry 'Debian GNU/Linux, with Linux 3.2.0-4-rt-686-pae' --class debian --class gnu-linux --class gnu --class os {
  load_video
  insmod gzio
  insmod part_msdos
  insmod ext2
  set root='(hd0,msdos1)'
  search --no-floppy --fs-uuid --set=root 6a2a2731-147e-49f9-866f-70cbf61d234c
  echo	'Loading Linux 3.2.0-4-rt-686-pae ...'
  linux	/boot/vmlinuz-3.2.0-4-rt-686-pae root=UUID=6a2a2731-147e-49f9-866f-70cbf61d234c ro  quiet
  echo	'Loading initial ramdisk ...'
  initrd	/boot/initrd.img-3.2.0-4-rt-686-pae
}
menuentry 'Debian GNU/Linux, with Linux 3.2.0-4-rt-686-pae (recovery mode)' --class debian --class gnu-linux --class gnu --class os {
  load_video
  insmod gzio
  insmod part_msdos
  insmod ext2
  set root='(hd0,msdos1)'
  search --no-floppy --fs-uuid --set=root 6a2a2731-147e-49f9-866f-70cbf61d234c
  echo	'Loading Linux 3.2.0-4-rt-686-pae ...'
  linux	/boot/vmlinuz-3.2.0-4-rt-686-pae root=UUID=6a2a2731-147e-49f9-866f-70cbf61d234c ro single
  echo	'Loading initial ramdisk ...'
  initrd	/boot/initrd.img-3.2.0-4-rt-686-pae
}
''
