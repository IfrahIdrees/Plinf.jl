
(define (problem blocks_words) (:domain blocks)
  (:objects
    t - block
	u - block
	n - block
	e - block
	o - block
	c - block
	a - block
	p - block
	s - block
	r - block
	h - block
	w - block
	k - block
  )
  (:init 
	(clear t)
	(clear u)
	(clear n)
	(clear e)
	(clear o)
	(clear c)
	(clear a)
	(clear p)
	(clear s)
	(clear r)
	(clear h)
	(clear w)
	(clear k)
	(eq t t)
	(eq u u)
	(eq n n)
	(eq e e)
	(eq o o)
	(eq c c)
	(eq a a)
	(eq p p)
	(eq s s)
	(eq r r)
	(eq h h)
	(eq w w)
	(eq k k)
	(handempty)
	(ontable t)
	(ontable u)
	(ontable n)
	(ontable e)
	(ontable o)
	(ontable c)
	(ontable a)
	(ontable p)
	(ontable s)
	(ontable r)
	(ontable h)
	(ontable w)
	(ontable k)
  )
  (:goal (and (clear t) (ontable e) (on t o) (on o n) (on n e) (clear h) (ontable k) (on h a) (on a w) (on w k) )
)
        