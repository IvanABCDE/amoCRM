let
    q = Web.Contents("https://raw.githubusercontent.com/IvanABCDE/amoCRM/master/Query3-4.m"),
    sourceFn = Expression.Evaluate(
        Text.FromBinary(
            Binary.Buffer(q)
        ), #shared)
in
    sourceFn