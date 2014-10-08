if did_filetype()
    finish
endif
if getline(1) =~ '^"!AddressBook\>'
    setf addr
endif

