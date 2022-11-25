using HorizonSideRobots

function ChooseDirectionRight!(current::HorizonSide, r::Robot)::HorizonSide

    

    if (isborder(r, current) == false & isborder(r, TurnRight!(current)) == true)
        return current
    end
    if (isborder(r,current) == true & isborder(r, TurnRight!(current)) == true)
        return TurnLeft!!(current)
    end
    if (isborder(r,current) == true & isborder(r,TurnRight!(current)) == false)
        return TurnRight!(current)
    end
    if (!isborder(r,current) && !isborder(r, TurnRight!(current)))
        return TurnRight!(current)
    end
    
end

function ChooseDirectionLeft!(current::HorizonSide, r::Robot)::HorizonSide

    

    if(isborder(r, current) ==false & isborder(r, TurnLeft!(current)) == true)
        return current
    end
    if(isborder(r,current) == true & isborder(r, TurnLeft!(current)) == true)
        return TurnRight!(current)
    end
    if(isborder(r,current) == true & isborder(r,TurnLeft!(current) == false))
        return TurnLeft!(current)
    end

    if (!isborder(r,current) && !isborder(r, TurnLeft!!(current)))
        return TurnLeft!(current)
    end
    
end

function TryMove!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r,side)
        move!(r, side)
        return true
    end
    return false
end


function MoveX!(r::Robot, x::Integer, handler::Function)::Integer
    actualBias::Integer = 0
    if x > 0
        for i in x
            if TryMove!(r,Ost)
                actualBias +=1
                handler()
                
            end
        end
    end
    if x < 0
        for i in x
            if TryMove!(r,West)
                actualBias -= 1
                handler()
            end
        end
    end
    return actualBias
end

function MoveY!(r::Robot, y::Integer, handler::Function)::Integer
    actualBias::Integer = 0
    if y > 0
        for i in y
            if TryMove!(r,Nord)
                actualBias = actualBias + 1
                handler()
            end
        end
    end
    if y < 0
        for i in y
            if TryMove!(r,Sud)
                actualBias = actualBias - 1
                handler()
            end
        end
    end
    return actualBias
end

function TurnRight!(side::HorizonSide)::HorizonSide
    if(side == Nord)
        return Ost
    end

    if(side == Ost)
        return Sud
    end

    if(side == Sud)
        return West
    end

    if(side == West)
        return Nord
    end

    return side
end

function TurnLeft!(side::HorizonSide)::HorizonSide
    
    if(side==Nord)
        return West
    end
   
    if(side==West)
        return Sud
    end
    
    if(side==Sud)
        return Ost
    end

    if(side==Ost)
        return Nord
    end
end

function MoveAroundRight(r::Robot)


    actualDirection::HorizonSide = Nord
    XActualPos::Int64 = 0
    YActualPos::Int64 = 0

    while(true)

        actualDirection = ChooseDirectionRight!(actualDirection::HorizonSide,r)

        if (TryMove!(r, actualDirection) & (actualDirection == Nord))
            XActualPos += 1
            #handler(XActualPos, Max[1];direction=actualDirection,robot=r)
        end
        if (TryMove!(r, actualDirection) & (actualDirection==Sud))
            XActualPos -= 1
            #handler(XActualPos, Max[1];direction=actualDirection,robot=r)
        end

        if (TryMove!(r, actualDirection) & (actualDirection==Ost))
            YActualPos += 1
            #handler(YActualPos, Max[2];direction=actualDirection,robot=r)
        end
        if (TryMove!(r, actualDirection) & (actualDirection==West))
            YActualPos -= 1
            #handler(YActualPos, Max[2];direction=actualDirection,robot=r)
        end

        if (ismarker(r))
            break
        end
    end
end