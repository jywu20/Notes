program branching
    use omp_lib
    implicit none
    
    integer :: thread_id
    integer :: thread_num
    integer :: i
    
    ! Note that thread_id by default is shared by all threads,
    ! but in the code block below, it should have a different value for each thread.
    ! Note that the code block below has no serial correspondence:
    ! to write code with serial correspondence,
    ! we need parallel for/do.
    ! Another choice is the section construct.
    print *, "Demonstration 1: thread id display"
    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    thread_num = omp_get_num_threads()
    print "(A, I3, A, I3)", "Thread ", thread_id, '  /', thread_num
    !$omp end parallel
    print *, ""
    
    ! In the code block below, we start a parallel construct 
    ! with statements printing the index of the current thread,
    ! and then we write a do construct,
    ! which is distributed to the threads.
    ! In the output, we will find that the output of different threads are completely mixed together.
    print *, "Demonstration 2: for loop mixed with plain parallel construct"
    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    thread_num = omp_get_num_threads()
    print "(A, I3, A, I3)", "Thread ", thread_id, '  /', thread_num

    !$omp do 
    do i = 1, 16
        print "(A, I3, A, I3, A, I3)", "Thread ", thread_id, "  /", thread_num, " dealing with iteration ", i
    end do
    !$omp end do
    !$omp end parallel
    print *, ""
    
    ! Now after we insert a barrier, the threads first report their ids,
    ! and then report the iterations they are dealing with.
    ! Of course, the orders of the output of the threads in the two steps are still random.
    print *, "Demonstration 3: for loop mixed with plain parallel construct, with barrier"
    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    thread_num = omp_get_num_threads()
    print "(A, I3, A, I3)", "Thread ", thread_id, '  /', thread_num
    
    !$omp barrier

    !$omp do 
    do i = 1, 16
        print "(A, I3, A, I3, A, I3)", "Thread ", thread_id, "  /", thread_num, " dealing with iteration ", i
    end do
    !$omp end do
    !$omp end parallel
    print *, ""
    
    ! The master construct limits execution of some statements to the master thread and a random single thread.
    ! The master thread is always the 0th thread,
    ! while the single construct is run on a random thread.
    print *, "Demonstration 4: the master block"
    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    thread_num = omp_get_num_threads()
    
    !$omp master
    print "(A, I3, A, I3)", "Master thread is              ", thread_id, '  /', thread_num
    !$omp end master

    !$omp single
    print "(A, I3, A, I3)", "A particular single thread is ", thread_id, '  /', thread_num
    !$omp end single

    !$omp end parallel
    print *, ""
    
    ! A code block can be divided into several independent sections,
    ! and then the sections run in parallel.
    ! Note that the number of the threads launched is the same as the number of sections.
    print *, "Demonstration 5: sections"
    !$omp parallel 
    !$omp sections
    
    !$omp section
    print *, "Section 1"

    !$omp section
    print *, "Section 2"

    !$omp end sections
    !$omp end parallel
contains
    
end program branching