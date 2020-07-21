export fn fib(N: u32) u32 {
    var i: u32 = 0;
    var j: u32 = 1;
    var k = j;
    var n = N;
    while (n > 0) : (n -= 1) {
        var tmp: u32 = i;
        i = j;
        j = tmp + j;
    }

    return j;
}
