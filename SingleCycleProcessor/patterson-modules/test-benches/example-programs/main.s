	.text
	.org 0x0000
	Exit: 
	LDUR x1, [x2, #8]
  LDUR x1, [x2, #-8]
  STUR x1, [x2, #8]
  STUR x2, [x2, #-8]
  CBZ x1, -256
  CBZ x1, Next 
  Next:
