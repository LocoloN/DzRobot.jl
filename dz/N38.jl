using HorizonSideRobots


function TryMove(r::Robot,side::HorizonSide)::Bool
if(!isborder(r,side))
    move!(r,side)
    return true
end
return false
end

function CheckTurn(current::HorizonSide, previous::HorizonSide)::Integer # 1-левый поворот, 2 - правый поворот, 0-нет поворота

    if(current == previous)
        return 0
    end
    if(current == TurnLeft(previous))
        return 1
    end
    if(current == TurnRight(previous))
        return 2
    end

end

abstract type AbstractRobot 
end

struct GenericRobot <: AbstractRobot
robot::Robot
end

function StopCondition(coord::AbstractVector{Integer},
    startDir::HorizonSide,
    currentDir::HorizonSide)::Bool
    
    if (coord[1]==0 && coord[2]==0 && startDir == currentDir)
        return true
    end  
    return false
end

function Summary(turns::AbstractVector{Integer})::Int8 # 0-внутри 1-снаружи 2-ошибка
    if (turns[1] > turns[2])
        return 0
    end
    if (turns[1] < turns[2])
        return 1
    end
    if (turns[1] == turns[2])
        return 2
    end
    
end

function GetRobot(r::GenericRobot)::Robot
    return r.robot
end

TryMove(r::AbstractRobot,side::HorizonSide) = TryMove(GetRobot(r),side)
ChooseDirection(r::AbstractRobot, direction::HorizonSide) = ChooseDirection(GetRobot(r), direction)
ChooseFirstDirection(r::AbstractRobot) = ChooseFirstDirection(GetRobot(r))

function AroundBorder(r::AbstractRobot)::Int8 
    
    turns::AbstractVector{Integer} = [0,0]

    direction::HorizonSide = Nord
    previousMoveDirection::HorizonSide = Nord
    direction = ChooseFirstDirection(r)
    startDirection::HorizonSide = direction
    
    coord::AbstractVector{Integer} = [0,0]

    while (true)
        if (TryMove(r,direction))
            previousMoveDirection = direction

            if (direction == Nord || direction == Sud)
                coord[1]=coord[1]+Counter(direction)
            else
                coord[2]=coord[2]+Counter(direction)
            end

            direction = ChooseDirection(r,direction)
            if (CheckTurn(direction, previousMoveDirection) == 1)
                turns[1] = turns[1] + 1
            end
            if (CheckTurn(direction, previousMoveDirection) == 2)
                turns[2] = turns[2] + 1
            end

        else 
            ChooseDirection(r,direction)
        end                                                      
        
        if (StopCondition(coord,startDirection,direction))
            return Summary(turns)
            break
        end  
    end

end

function Empty()
    return Nothing
end

function Counter(side::HorizonSide)::Int32
    if (side==Nord)
    return 1

    end
    if(side==Ost)
    return+1

    end
    if(side==Sud)
    return -1

    end
    if(side==West)
    return -1

    end

end

function TurnRight(side::HorizonSide)::HorizonSide

    if(side==Nord)
    return Ost::HorizonSide
    end

    if(side==Ost)
    return Sud::HorizonSide
    end

    if(side==Sud)
    return West::HorizonSide
    end

    if(side==West)
    return Nord::HorizonSide
    end

end

function TurnLeft(side::HorizonSide)
    if(side == Nord)
        return West
    end

    if(side == West)
        return Sud
    end

    if(side == Sud)
        return Ost
    end

    if(side == Ost)
        return Nord
    end
    
end

function ChooseFirstDirection(r::Robot)::HorizonSide
    direction::HorizonSide = Nord
    while (!isborder(r,TurnRight(direction)))
        direction = TurnRight(direction)
    end
    return direction
end

function ChooseDirection(r::Robot,direction::HorizonSide)::HorizonSide
    if(isborder(r,direction) && isborder(r,TurnRight(direction)) && isborder(r,TurnLeft(direction)))
        return TurnRight(TurnRight(direction))
    end
    
    if(!isborder(r,direction) && isborder(r,TurnRight(direction)))
        return direction
    end
    if(!isborder(r,direction) && !isborder(r,TurnRight(direction)))
        return TurnRight(direction)
    end
    if(isborder(r,direction) && isborder(r,TurnRight(direction)))
        return TurnLeft(direction)
    end
    if(isborder(r,direction) && !isborder(r,TurnRight(direction)))
        return TurnRight(direction)
    end
end