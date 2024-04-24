#### LINUX
# PhotoRec Sorter

This script connect raw & jpg restored with **PhotoRec** to same folder and filename passing by its creation/modification date as filename.

---

### Restored directory

```
	recup_dir.1
		f18586752.cr2
		f18586752.jpg
		f18611840.jpg
		f18612864.cr2
		...
	recup_dir.2
	recup_dir.*
	...
```

### Sorted directory

```
	20210807
		20210807_171620.jpg
		20210807_171620.cr2
		20210807_171602.jpg
		20210807_171602.cr2
		...
	20210529
	20200801
	...
	log_20240424_1958
```

### Logfile

Contains path to source raw/jpg file and its new name to check what was not connected.

### RAW extensions (common)

```
Kodak : dcr, k25, kdc
Canon : rw, cr2, cr3
Nikon : nef, nrw
Olympus : orf
Pentax : pef
Panasonic : rw2
Sony : arw, srf, sr2
```