struct Test {
    reference: Box<i32>
}

fn weird(test: Test) -> i32 {
    let i = *(test.reference);
    let i2: i32 = *(test.reference);
    i2
}

fn main() {
    let test = Test{reference: Box::new(32)};
    let res = weird(test);
    println!("{res}");
}

struct A(i32);

fn main2(){
    let a = A(1);
    let ra = Box::new(a);
    let x = *ra;
    //let ra2 = ra;

}




use std::ops::Deref;


struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}

fn main3(){
    let a = A(1);
    let ra = MyBox::new(a);
    let x = *ra;
}
