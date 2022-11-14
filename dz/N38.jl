module N38
using .HorizonSideRobots
include("..\\src\\HorizonSideRobots.jl")

    function SetMaximum!(x::Integer, currentMaximum::Integer; direction::HorizonSide, robot::Robot)::Integer
        if(abs(x) > abs(currentMaximum))
            currentMaximum = x
        end
        return currentMaximum
    end
    
    function ChooseDirectionRight!(current::HorizonSide, r::Robot)::HorizonSide

        if(length(CheckBorder!(r)) == 3)
            return TurnRight!(TurnRight!(current))
        end

        if(isborder(r, current) ==false & isborder(r, TurnRight!(current)) == true)
            return current
        end
        if(isborder(r,current) == true & isborder(r, TurnRight!(current)) == true)
            return TurnLeft!(current)
        end
        if(isborder(r,current) == true & isborder(r,TurnRight!(current)) == false)
            return TurnRight!(current)
        end
        if(length(CheckBorder!(r)) == 0)
            return TurnRight!(current)
        end
        
    end
    
    function ChooseDirectionLeft!(current::HorizonSide)::HorizonSide

        if(length(CheckBorder!(r)) == 3)
            return TurnLeft(TurnLeft(current))
        end

        if(isborder(r, current) ==false & isborder(r, TurnLeft(current)) == true)
            return current
        end
        if(isborder(r,current) == true & isborder(r, TurnLeft(current)) == true)
            return TurnRight(current)
        end
        if(isborder(r,current) == true & isborder(r,TurnLeft(current) == false))
            return TurnLeft(current)
        end

        if(length(CheckBorder!(r)) == 0)
            return TurnLeft(current)
        end
        
    end


function MovementRight!(r::Robot,handler::Function)::Nothing

        XCurrentMaximum::Integer = 0
        YCurrentMaximum::Integer = 0

        XActualPos::Integer = 0
        YActualPos::Integer = 0

        actualDirection::HorizonSide = Nord

        while(true)
                
            actualDirection = ChooseDirectionRight!(actualDirection,r)

            if(TryMove!(r, actualDirection) & (actualDirection == Nord))
                XActualPos += 1
                handler(XActualPos, XCurrentMaximum;direction=actualDirection,robot=r)
            end
            if(TryMove!(r, actualDirection) & (actualDirection==Sud))
                XActualPos -= 1
                handler(XActualPos, XCurrentMaximum;direction=actualDirection,robot=r)
            end

            if(TryMove!(r, actualDirection) & (actualDirection==Ost))
                YActualPos += 1
                handler(YActualPos, XCurrentMaximum;direction=actualDirection,robot=r)
            end
            if(TryMove!(r, actualDirection) & (actualDirection==West))
                YActualPos -= 1
                handler(YActualPos, XCurrentMaximum;direction=actualDirection,robot=r)
            end
            
            if((XActualPos == 0) & (YActualPos == 0))
                break
            end 
        end
        return Nothing
    end

   

    function FinalCheck(actual::Integer, current::Integer; direction::HorizonSide, robot::Robot)
        if(actual == current & isborder(robot, TurnLeft(position)) == false)
            move!(robot, ChooseDirectionRight(direction))
            if(ChooseDirectionRight(ChooseDirectionRight(direction)) == West)
                print("Снаружи")
            end
            else
                print("Внутри")
                
            end
        end
    end

    function CheckIfInside!()
        
        r = Robot(animate=true)

        if length(CheckBorder!(r))==4
            return true
        end

        
        XCurrentMaximum::Integer = 0
        YCurrentMaximum::Integer = 0

        XActualPos::Integer = 0
        YActualPos::Integer = 0


        MovementRight!(r,SetMaximum!)

        MovementRight!(r,FinalCheck!)
        
        return Nothing
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

    function CheckBorder!(r::Robot)::Array{HorizonSide,1}
        A = Array{HorizonSide}([])
        for i in instances(HorizonSide)
            if isborder(r, i)
            push!(A,i)
            end
        end 

        if isempty(A)
        return Nothing
        end
        return A
    end

    function TurnRight!(side::HorizonSide)::HorizonSide
        if(side == Nord)
            return Ost::HorizonSide
        end

        if(side == Ost)
            return Sud::HorizonSide
        end

        if(side == Sud)
            return West::HorizonSide
        end

        if(side == West)
            return Nord::HorizonSide
        end
        return side::HorizonSide
    end

    function TurnLeft(side::HorizonSide)::HorizonSide
        
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

    
    CheckIfInside!()
    
end