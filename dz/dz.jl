module dz

    include("..\\src\\HorizonSideRobots.jl")
    using .HorizonSideRobots

    r = Robot(animate = true)

    function MakeCross()::Nothing
        for i::Integer in 1:6
            move!(r,Ost)
        end

        putmarker!(r)

        while(isborder(r,Nord) == false)
            move!(r,Nord)
            putmarker!(r)
        end

        putmarker!(r)

        while(isborder(r,Ost) == false)
            move!(r,Ost)
        end

        for j::Integer in 1:5
            move!(r,Sud)
        end

        putmarker!(r)

        while(isborder(r,West) == false)
            move!(r,West)
            putmarker!(r)

        end
    end
    function MakeObliqueCross()::Nothing
        putmarker!(r)

        while(isborder(r,Nord) == false)
            move!(r,Ost)
            move!(r,Nord)
            putmarker!(r)
        end

        while(isborder(r, West) ==false)
            move!(r,West)
        end

        putmarker!(r)

        while(isborder(r,Sud) == false)
            move!(r,Ost)
            move!(r,Sud)
            putmarker!(r)
        end
    end
    MakeObliqueCross()
end 