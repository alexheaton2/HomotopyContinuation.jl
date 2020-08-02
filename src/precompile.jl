const __bodyfunction__ = Dict{Method,Any}()

# Find keyword "body functions" (the function that contains the body
# as written by the developer, called after all missing keyword-arguments
# have been assigned values), in a manner that doesn't depend on
# gensymmed names.
# `mnokw` is the method that gets called when you invoke it without
# supplying any keywords.
function __lookup_kwbody__(mnokw::Method)
    function getsym(arg)
        isa(arg, Symbol) && return arg
        @assert isa(arg, GlobalRef)
        return arg.name
    end

    f = get(__bodyfunction__, mnokw, nothing)
    if f === nothing
        fmod = mnokw.module
        # The lowered code for `mnokw` should look like
        #   %1 = mkw(kwvalues..., #self#, args...)
        #        return %1
        # where `mkw` is the name of the "active" keyword body-function.
        ast = Base.uncompressed_ast(mnokw)
        if isa(ast, Core.CodeInfo) && length(ast.code) >= 2
            callexpr = ast.code[end-1]
            if isa(callexpr, Expr) && callexpr.head == :call
                fsym = callexpr.args[1]
                if isa(fsym, Symbol)
                    f = getfield(fmod, fsym)
                elseif isa(fsym, GlobalRef)
                    if fsym.mod === Core && fsym.name === :_apply
                        f = getfield(mnokw.module, getsym(callexpr.args[2]))
                    elseif fsym.mod === Core && fsym.name === :_apply_iterate
                        f = getfield(mnokw.module, getsym(callexpr.args[3]))
                    else
                        f = getfield(fsym.mod, fsym.name)
                    end
                else
                    f = missing
                end
            else
                f = missing
            end
        else
            f = missing
        end
        __bodyfunction__[mnokw] = f
    end
    return f
end

function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{AffineChartSystem{InterpretedSystem{Float64},1},Array{Variable,1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.ModelKit.Type)),NamedTuple{(:variables, :parameters),Tuple{Array{Variable,1},Array{Variable,1}}},Type{System},Array{Array{Int32,2},1},Array{Array{Variable,1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.ModelKit.buildvars)),NamedTuple{(:unique,),Tuple{Bool}},typeof(HomotopyContinuation.ModelKit.buildvars),Tuple{Expr,Expr,Expr}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.ModelKit.buildvars)),NamedTuple{(:unique,),Tuple{Bool}},typeof(HomotopyContinuation.ModelKit.buildvars),Tuple{Symbol,Symbol,Symbol}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.ModelKit.buildvars)),NamedTuple{(:unique,),Tuple{Bool}},typeof(HomotopyContinuation.ModelKit.buildvars),Tuple{Symbol,Symbol}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:options,),Tuple{EndgameOptions}},Type{EndgameTracker},Tracker{CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:options,),Tuple{EndgameOptions}},Type{EndgameTracker},Tracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:options,),Tuple{EndgameOptions}},Type{EndgameTracker},Tracker{StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:options,),Tuple{TrackerOptions}},Type{Tracker},CoefficientHomotopy{InterpretedSystem{Float64}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:options,),Tuple{TrackerOptions}},Type{Tracker},HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:return_code, :solution, :t, :singular, :accuracy, :residual, :condition_jacobian, :winding_number, :last_path_point, :valuation, :start_solution, :path_number, :ω, :μ, :extended_precision, :accepted_steps, :rejected_steps, :steps_eg, :extended_precision_used),Tuple{Symbol,Array{Complex{Float64},1},Float64,Bool,Float64,Float64,Float64,Nothing,Tuple{Array{Complex{Float64},1},Float64},Array{Float64,1},Array{Complex{Float64},1},Int64,Float64,Float64,Bool,Int64,Int64,Int64,Bool}},Type{PathResult}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:return_code, :solution, :t, :singular, :accuracy, :residual, :condition_jacobian, :winding_number, :last_path_point, :valuation, :start_solution, :path_number, :ω, :μ, :extended_precision, :accepted_steps, :rejected_steps, :steps_eg, :extended_precision_used),Tuple{Symbol,Array{Complex{Float64},1},Float64,Bool,Float64,Float64,Float64,Nothing,Tuple{Array{Complex{Float64},1},Float64},Array{Float64,1},Array{Complex{Float64},1},Nothing,Float64,Float64,Bool,Int64,Int64,Int64,Bool}},Type{PathResult}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Nothing}},Type{Result},Array{PathResult,1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Nothing}},Type{Solver},EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Symbol}},Type{Result},Array{PathResult,1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Symbol}},Type{Solver},EndgameTracker{StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Symbol}},Type{Solver},OverdeterminedTracker{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},HomotopyContinuation.ExcessSolutionCheck{RandomizedSystem{InterpretedSystem{Float64}},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:seed, :start_system),Tuple{UInt32,Symbol}},Type{Solver},PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:system, :system_coeffs, :weights, :t_weights, :complex_t_weights, :coeffs, :dt_coeffs, :x, :t_coeffs, :t_taylor_coeffs, :taylor_coeffs, :tc3, :tc2),Tuple{InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Float64,1},Array{Float64,1},StructArrays.StructArray{Complex{Float64},1,NamedTuple{(:re, :im),Tuple{Array{Float64,1},Array{Float64,1}}},Int64},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},Base.RefValue{Complex{Float64}},Base.RefValue{Complex{Float64}},TaylorVector{5,Complex{Float64}},TaylorVector{4,Complex{Float64}},TaylorVector{3,Complex{Float64}}}},Type{HomotopyContinuation.ToricHomotopy}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:tracker_options, :options),Tuple{TrackerOptions,EndgameOptions}},Type{EndgameTracker},ParameterHomotopy{InterpretedSystem{Float64}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:tracker_options, :options),Tuple{TrackerOptions,EndgameOptions}},Type{EndgameTracker},StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:tx⁰, :tx¹, :tx², :tx³, :xtemp, :u, :u₁, :u₂, :prev_tx¹, :ty¹, :prev_ty¹),Tuple{TaylorVector{1,Complex{Float64}},TaylorVector{2,Complex{Float64}},TaylorVector{3,Complex{Float64}},TaylorVector{4,Complex{Float64}},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},TaylorVector{2,Complex{Float64}},TaylorVector{2,Complex{Float64}},TaylorVector{2,Complex{Float64}}}},Type{HomotopyContinuation.Predictor}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:val, :solution, :row_scaling, :samples),Tuple{HomotopyContinuation.Valuation,Array{Complex{Float64},1},Array{Float64,1},Array{TaylorVector{2,Complex{Float64}},1}}},Type{HomotopyContinuation.EndgameTrackerState}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.Type)),NamedTuple{(:γ,),Tuple{Complex{Float64}}},Type{StraightLineHomotopy},FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.monodromy_solve)),NamedTuple{(:show_progress, :threading, :catch_interrupt),Tuple{Bool,Bool,Bool}},typeof(monodromy_solve),HomotopyContinuation.MonodromySolver{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},Array{Complex{Float64},1},UniquePoints{Complex{Float64},Int64,EuclideanNorm,Nothing},MonodromyOptions{EuclideanNorm,typeof(HomotopyContinuation.always_false),Nothing,typeof(HomotopyContinuation.independent_normal)}},Array{Array{Complex{Float64},1},1},Array{Complex{Float64},1},UInt32})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.monodromy_solve)),NamedTuple{(:target_solutions_count, :max_loops_no_progress, :compile),Tuple{Int64,Int64,Bool}},typeof(monodromy_solve),System})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.newton)),NamedTuple{(:atol, :rtol),Tuple{Float64,Float64}},typeof(newton),HomotopyContinuation.StartPairSystem{InterpretedSystem{Float64},FiniteDiff.JacobianCache{Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},UnitRange{Int64},Nothing,Val{:forward},Complex{Float64}}},Array{Complex{Float64},1},Nothing,InfNorm,NewtonCache{Array{Complex{Float64},2}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.polyhedral)),NamedTuple{(:compile,),Tuple{Bool}},typeof(polyhedral),Array{Array{Int32,2},1},Array{Array{Complex{Float64},1},1},Array{Array{Float64,1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.polyhedral)),NamedTuple{(:compile,),Tuple{Bool}},typeof(polyhedral),Array{Array{Int32,2},1},Array{Array{Complex{Float64},1},1},Array{Array{T,1} where T,1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.polyhedral)),NamedTuple{(:compile,),Tuple{Bool}},typeof(polyhedral),Array{Array{Int32,2},1},Array{Array{Complex{Float64},1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.polyhedral)),NamedTuple{(:compile,),Tuple{Bool}},typeof(polyhedral),Array{Array{Int32,2},1},Array{Array{Float64,1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.polyhedral)),NamedTuple{(:compile,),Tuple{Bool}},typeof(polyhedral),Array{Array{Int32,2},1},Array{Array{T,1} where T,1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:compile, :start_system),Tuple{Bool,Symbol}},typeof(solve),System})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:compile,),Tuple{Bool}},typeof(solve),System})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:start_parameters, :target_parameters, :compile),Tuple{Array{Complex{Float64},1},Array{Float64,1},Bool}},typeof(solve),System,Array{Array{Complex{Float64},1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:stop_early_cb, :show_progress, :threading, :catch_interrupt),Tuple{typeof(HomotopyContinuation.always_false),Bool,Bool,Bool}},typeof(solve),Solver{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Array{Complex{Float64},1},1}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:stop_early_cb, :show_progress, :threading, :catch_interrupt),Tuple{typeof(HomotopyContinuation.always_false),Bool,Bool,Bool}},typeof(solve),Solver{EndgameTracker{StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},Array{Complex{Float64},2}}},HomotopyContinuation.TotalDegreeStartSolutionsIterator{Base.Iterators.ProductIterator{Tuple{UnitRange{Int64},UnitRange{Int64}}}}})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:stop_early_cb, :show_progress, :threading, :catch_interrupt),Tuple{typeof(HomotopyContinuation.always_false),Bool,Bool,Bool}},typeof(solve),Solver{OverdeterminedTracker{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},HomotopyContinuation.ExcessSolutionCheck{RandomizedSystem{InterpretedSystem{Float64}},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}}},PolyhedralStartSolutionsIterator})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.solve)),NamedTuple{(:stop_early_cb, :show_progress, :threading, :catch_interrupt),Tuple{typeof(HomotopyContinuation.always_false),Bool,Bool,Bool}},typeof(solve),Solver{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},PolyhedralStartSolutionsIterator})
    Base.precompile(Tuple{Core.kwftype(typeof(HomotopyContinuation.total_degree_start_solutions)),NamedTuple{(:homogeneous,),Tuple{Bool}},typeof(total_degree_start_solutions),Array{Int64,1}})
    Base.precompile(Tuple{RandomizedSystem{InterpretedSystem{Float64}},Array{Variable,1}})
    Base.precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(*),Tuple{Array{Variable,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(-),Tuple{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}},Int64}}}})
    Base.precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(-),Tuple{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}},Int64}})
    Base.precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}})
    Base.precompile(Tuple{Type{CoefficientHomotopy},InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Complex{Float64},1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ExcessSolutionCheck},RandomizedSystem{InterpretedSystem{Float64}},NewtonCache{HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}})
    Base.precompile(Tuple{Type{HomotopyContinuation.Jacobian},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}},Base.RefValue{Int64},Base.RefValue{Int64}})
    Base.precompile(Tuple{Type{HomotopyContinuation.MatrixWorkspace},Array{Complex{Float64},2},Array{Float64,1},Base.RefValue{Bool},LinearAlgebra.LU{Complex{Float64},Array{Complex{Float64},2}},LinearAlgebra.QR{Complex{Float64},Array{Complex{Float64},2}},Array{Float64,1},Base.RefValue{Bool},Array{Complex{HomotopyContinuation.DoubleDouble.DoubleF64},1},Array{Complex{Float64},1},Array{Complex{HomotopyContinuation.DoubleDouble.DoubleF64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Float64,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Any,1},Float64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Any,1},Int64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Any,1},Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Float64,1},Int64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Float64,1},Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Int64,1},Int64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterArg},Dict{Symbol,Int64},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Int64,1},Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Float64,Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Int64,Int64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Int64,Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Symbol,Float64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Symbol,Int64})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.InterpreterOp},Symbol,Symbol,Symbol})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},Array{HomotopyContinuation.ModelKit.InterpreterInstruction,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1},Array{Float64,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},Array{HomotopyContinuation.ModelKit.InterpreterInstruction,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1},Array{Int64,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},Array{HomotopyContinuation.ModelKit.InterpreterInstruction,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,2},Array{Float64,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},Array{HomotopyContinuation.ModelKit.InterpreterInstruction,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,2},Array{Int64,1},Array{HomotopyContinuation.ModelKit.InterpreterArg,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},HomotopyContinuation.ModelKit.InstructionList,Array{Any,2},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Symbol,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},HomotopyContinuation.ModelKit.InstructionList,Array{Symbol,1},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Symbol,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.ModelKit.Interpreter},HomotopyContinuation.ModelKit.InstructionList,Array{Symbol,2},Dict{Symbol,Int64},Nothing,Dict{Symbol,Int64},Array{Symbol,1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.MonodromySolver},Array{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},1},Array{HomotopyContinuation.MonodromyLoop{Array{Complex{Float64},1}},1},UniquePoints{Complex{Float64},Int64,EuclideanNorm,Nothing},ReentrantLock,MonodromyOptions{EuclideanNorm,typeof(HomotopyContinuation.always_false),Nothing,typeof(HomotopyContinuation.independent_normal)},HomotopyContinuation.MonodromyStatistics,Array{Complex{Float64},1},ReentrantLock})
    Base.precompile(Tuple{Type{HomotopyContinuation.ToricHomotopy},InterpretedSystem{Float64},Array{Array{Complex{Float64},1},1}})
    Base.precompile(Tuple{Type{HomotopyContinuation.TotalDegreeStartSolutionsIterator},Array{Int64,1},Bool,Base.Iterators.ProductIterator{Tuple{UnitRange{Int64},UnitRange{Int64}}}})
    Base.precompile(Tuple{Type{HomotopyContinuation.TrackerState},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},HomotopyContinuation.SegmentStepper,Float64,Float64,Float64,Float64,Float64,Float64,Float64,Bool,Bool,Bool,Bool,WeightedNorm{InfNorm},Bool,HomotopyContinuation.Jacobian{Array{Complex{Float64},2}},Float64,HomotopyContinuation.TrackerCode.codes,Int64,Int64,Int64,Int64,Int64})
    Base.precompile(Tuple{Type{InterpretedSystem},System,HomotopyContinuation.ModelKit.Interpreter{Float64,1},HomotopyContinuation.ModelKit.InterpreterCache{Complex{Float64}},HomotopyContinuation.ModelKit.InterpreterCache{Complex{HomotopyContinuation.DoubleDouble.DoubleF64}},HomotopyContinuation.ModelKit.Interpreter{Float64,2},HomotopyContinuation.ModelKit.InterpreterCache{Complex{Float64}},Tuple{HomotopyContinuation.ModelKit.InterpreterCache{Tuple{Complex{Float64},Complex{Float64}}},HomotopyContinuation.ModelKit.InterpreterCache{Tuple{Complex{Float64},Complex{Float64},Complex{Float64}}},HomotopyContinuation.ModelKit.InterpreterCache{NTuple{4,Complex{Float64}}}}})
    Base.precompile(Tuple{Type{NamedTuple{(:system, :system_coeffs, :weights, :t_weights, :complex_t_weights, :coeffs, :dt_coeffs, :x, :t_coeffs, :t_taylor_coeffs, :taylor_coeffs, :tc3, :tc2),T} where T<:Tuple},Tuple{InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Float64,1},Array{Float64,1},StructArrays.StructArray{Complex{Float64},1,NamedTuple{(:re, :im),Tuple{Array{Float64,1},Array{Float64,1}}},Int64},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},Base.RefValue{Complex{Float64}},Base.RefValue{Complex{Float64}},TaylorVector{5,Complex{Float64}},TaylorVector{4,Complex{Float64}},TaylorVector{3,Complex{Float64}}}})
    Base.precompile(Tuple{Type{NamedTuple{(:tx⁰, :tx¹, :tx², :tx³, :xtemp, :u, :u₁, :u₂, :prev_tx¹, :ty¹, :prev_ty¹),T} where T<:Tuple},Tuple{TaylorVector{1,Complex{Float64}},TaylorVector{2,Complex{Float64}},TaylorVector{3,Complex{Float64}},TaylorVector{4,Complex{Float64}},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{Float64},1},TaylorVector{2,Complex{Float64}},TaylorVector{2,Complex{Float64}},TaylorVector{2,Complex{Float64}}}})
    Base.precompile(Tuple{Type{NamedTuple{(:val, :solution, :row_scaling, :samples),T} where T<:Tuple},Tuple{HomotopyContinuation.Valuation,Array{Complex{Float64},1},Array{Float64,1},Array{TaylorVector{2,Complex{Float64}},1}}})
    Base.precompile(Tuple{Type{NewtonCache},Array{Complex{Float64},1},Array{Complex{Float64},1},Array{Complex{HomotopyContinuation.DoubleDouble.DoubleF64},1},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}},Array{Complex{Float64},1}})
    Base.precompile(Tuple{Type{OverdeterminedTracker},PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},HomotopyContinuation.ExcessSolutionCheck{RandomizedSystem{InterpretedSystem{Float64}},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}})
    Base.precompile(Tuple{Type{OverdeterminedTracker},PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},RandomizedSystem{InterpretedSystem{Float64}}})
    Base.precompile(Tuple{Type{ParameterHomotopy},InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Complex{Float64},1}})
    Base.precompile(Tuple{Type{ParameterHomotopy},InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Float64,1}})
    Base.precompile(Tuple{Type{PolyhedralTracker},Tracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},EndgameTracker{CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},Array{Array{Int32,2},1},Array{Array{Int32,1},1}})
    Base.precompile(Tuple{Type{RandomizedSystem},InterpretedSystem{Float64},Array{Complex{Float64},2}})
    Base.precompile(Tuple{Type{System},Array{Expression,1},Array{Variable,1}})
    Base.precompile(Tuple{Type{System},Array{Expression,1}})
    Base.precompile(Tuple{Type{TaylorVector{1,Complex{Float64}}},LinearAlgebra.Transpose{Complex{Float64},Array{Complex{Float64},2}},Tuple{SubArray{Complex{Float64},1,Array{Complex{Float64},2},Tuple{Int64,UnitRange{Int64}},true}}})
    Base.precompile(Tuple{Type{TaylorVector{1,T} where T},TaylorVector{4,Complex{Float64}}})
    Base.precompile(Tuple{Type{TaylorVector{2,T} where T},TaylorVector{4,Complex{Float64}}})
    Base.precompile(Tuple{Type{TaylorVector{2,T} where T},Type{T} where T,Int64})
    Base.precompile(Tuple{Type{TaylorVector{3,T} where T},TaylorVector{4,Complex{Float64}}})
    Base.precompile(Tuple{Type{TaylorVector{3,T} where T},TaylorVector{5,Complex{Float64}}})
    Base.precompile(Tuple{Type{TaylorVector{4,T} where T},TaylorVector{5,Complex{Float64}}})
    Base.precompile(Tuple{Type{TaylorVector{4,T} where T},Type{T} where T,Int64})
    Base.precompile(Tuple{Type{TaylorVector{5,T} where T},Type{T} where T,Int64})
    Base.precompile(Tuple{Type{TaylorVector},LinearAlgebra.Transpose{Complex{Float64},Array{Complex{Float64},2}},NTuple{4,SubArray{Complex{Float64},1,Array{Complex{Float64},2},Tuple{Int64,UnitRange{Int64}},true}}})
    Base.precompile(Tuple{Type{TaylorVector},LinearAlgebra.Transpose{Complex{Float64},Array{Complex{Float64},2}},NTuple{5,SubArray{Complex{Float64},1,Array{Complex{Float64},2},Tuple{Int64,UnitRange{Int64}},true}}})
    Base.precompile(Tuple{Type{TaylorVector},LinearAlgebra.Transpose{Complex{Float64},Array{Complex{Float64},2}},Tuple{SubArray{Complex{Float64},1,Array{Complex{Float64},2},Tuple{Int64,UnitRange{Int64}},true},SubArray{Complex{Float64},1,Array{Complex{Float64},2},Tuple{Int64,UnitRange{Int64}},true}}})
    Base.precompile(Tuple{Type{Tracker},CoefficientHomotopy{InterpretedSystem{Float64}},HomotopyContinuation.Predictor,HomotopyContinuation.NewtonCorrector,HomotopyContinuation.TrackerState{Array{Complex{Float64},2}},TrackerOptions})
    Base.precompile(Tuple{Type{Tracker},HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},HomotopyContinuation.Predictor,HomotopyContinuation.NewtonCorrector,HomotopyContinuation.TrackerState{Array{Complex{Float64},2}},TrackerOptions})
    Base.precompile(Tuple{Type{Tracker},ParameterHomotopy{InterpretedSystem{Float64}},HomotopyContinuation.Predictor,HomotopyContinuation.NewtonCorrector,HomotopyContinuation.TrackerState{Array{Complex{Float64},2}},TrackerOptions})
    Base.precompile(Tuple{Type{Tracker},StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},HomotopyContinuation.Predictor,HomotopyContinuation.NewtonCorrector,HomotopyContinuation.TrackerState{Array{Complex{Float64},2}},TrackerOptions})
    Base.precompile(Tuple{typeof(*),Array{Complex{Float64},2},Array{Expression,1}})
    Base.precompile(Tuple{typeof(*),Complex{Int64},Expression})
    Base.precompile(Tuple{typeof(*),Expression,Expression})
    Base.precompile(Tuple{typeof(*),Float64,Expression})
    Base.precompile(Tuple{typeof(*),Int64,Variable})
    Base.precompile(Tuple{typeof(*),Variable,Variable})
    Base.precompile(Tuple{typeof(+),Expression,Expression,Expression,Expression})
    Base.precompile(Tuple{typeof(+),Expression,Expression,Expression})
    Base.precompile(Tuple{typeof(+),Expression,Expression})
    Base.precompile(Tuple{typeof(+),Expression,Float64})
    Base.precompile(Tuple{typeof(+),Expression,Int64})
    Base.precompile(Tuple{typeof(+),Variable,Int64})
    Base.precompile(Tuple{typeof(-),Expression,Expression})
    Base.precompile(Tuple{typeof(-),Expression,Int64})
    Base.precompile(Tuple{typeof(-),Variable,Variable})
    Base.precompile(Tuple{typeof(/),Expression,Expression})
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Array{Variable,1},Array{Int64,1}})
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Array{Variable,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(-),Tuple{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}},Int64}}})
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}},Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Complex{Float64},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Expression,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(horner),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Int64,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Tuple{Array{Int32,2},Array{Complex{Float64},1}},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Tuple{Array{Int32,2},Array{Float64,1}},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Tuple{String,Array{Int64,1}},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(HomotopyContinuation.ModelKit.sort_key),Tuple{Base.Broadcast.Extruded{Array{Variable,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.materialize),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(*),Tuple{Array{Variable,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(-),Tuple{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(^),Tuple{Array{Variable,1},Array{Int64,1}}},Int64}}}}})
    Base.precompile(Tuple{typeof(Base.Broadcast.restart_copyto_nonleaf!),Array{Number,1},Array{Complex{Float64},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Float64,Int64,Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.restart_copyto_nonleaf!),Array{Real,1},Array{Int64,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Float64,Int64,Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base.Broadcast.restart_copyto_nonleaf!),Array{Tuple{Array{Int32,2},Array{T,1} where T},1},Array{Tuple{Array{Int32,2},Array{Float64,1}},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Tuple{Array{Int32,2},Array{Complex{Float64},1}},Int64,Base.OneTo{Int64},Int64,Int64})
    Base.precompile(Tuple{typeof(Base._array_for),Type{TaylorVector{2,Complex{Float64}}},UnitRange{Int64},Base.HasShape{1}})
    Base.precompile(Tuple{typeof(Base._compute_eltype),Type{Tuple{Array{Array{Variable,1},1},Array{Variable,1}}}})
    Base.precompile(Tuple{typeof(Base._compute_eltype),Type{Tuple{typeof(HomotopyContinuation.always_false),Bool,Bool,Bool}}})
    Base.precompile(Tuple{typeof(Base._similar_for),Array{Expression,1},Type{Expression},Base.Generator{Array{Expression,1},typeof(to_number)},Base.HasShape{1}})
    Base.precompile(Tuple{typeof(Base.allocatedinline),Type{Complex{HomotopyContinuation.DoubleDouble.DoubleF64}}})
    Base.precompile(Tuple{typeof(Base.allocatedinline),Type{Expression}})
    Base.precompile(Tuple{typeof(Base.allocatedinline),Type{HomotopyContinuation.ModelKit.ExpressionRef}})
    Base.precompile(Tuple{typeof(Base.allocatedinline),Type{Variable}})
    Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Array{Expression,1},Expression,Base.Generator{Array{Expression,1},typeof(to_number)},Int64})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{Complex{HomotopyContinuation.DoubleDouble.DoubleF64},1},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{HomotopyContinuation.ModelKit.InterpreterArg,1},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{HomotopyContinuation.ModelKit.InterpreterArg,2},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{HomotopyContinuation.ModelKit.InterpreterInstruction,1},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{TaylorVector{2,Complex{Float64}},1},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Array{Variable,1},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.deepcopy_internal),Tuple{HomotopyContinuation.ModelKit.InterpreterCache{Tuple{Complex{Float64},Complex{Float64}}},HomotopyContinuation.ModelKit.InterpreterCache{Tuple{Complex{Float64},Complex{Float64},Complex{Float64}}},HomotopyContinuation.ModelKit.InterpreterCache{NTuple{4,Complex{Float64}}}},IdDict{Any,Any}})
    Base.precompile(Tuple{typeof(Base.literal_pow),typeof(^),Variable,Val{2}})
    Base.precompile(Tuple{typeof(Base.merge_types),Tuple{Symbol},Type{NamedTuple{(:metric,),Tuple{EuclideanNorm}}},Type{NamedTuple{(),Tuple{}}}})
    Base.precompile(Tuple{typeof(Base.vect),EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}})
    Base.precompile(Tuple{typeof(Base.vect),Expression,Vararg{Expression,N} where N})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.__init__)})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit._impl_taylor_bivariate),Int64,Int64,Int64,Symbol})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit._impl_taylor_pow),Int64,Int64})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit._impl_taylor_sqr),Int64,Int64})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.free!),Expression})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.free!),HomotopyContinuation.ModelKit.ExprVec})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.free!),HomotopyContinuation.ModelKit.ExpressionMap})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.free!),HomotopyContinuation.ModelKit.ExpressionSet})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.multivariate_horner),Array{Int32,2},Array{Expression,1},Array{Variable,1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.to_smallest_eltype),Array{Any,1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.to_smallest_eltype),Array{Complex{Float64},1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.to_smallest_eltype),Array{Number,1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.ModelKit.to_smallest_eltype),Array{Real,1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.qr_ldiv!),Array{Complex{Float64},1},LinearAlgebra.QR{Complex{Float64},Array{Complex{Float64},2}},Array{Complex{Float64},1}})
    Base.precompile(Tuple{typeof(HomotopyContinuation.threaded_monodromy_solve!),Array{PathResult,1},HomotopyContinuation.MonodromySolver{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},Array{Complex{Float64},1},UniquePoints{Complex{Float64},Int64,EuclideanNorm,Nothing},MonodromyOptions{EuclideanNorm,typeof(HomotopyContinuation.always_false),Nothing,typeof(HomotopyContinuation.independent_normal)}},Array{Complex{Float64},1},UInt32,ProgressMeter.ProgressUnknown})
    Base.precompile(Tuple{typeof(append!),Array{Expression,1},Array{Float64,1}})
    Base.precompile(Tuple{typeof(append!),Array{Variable,1},Array{Variable,1}})
    Base.precompile(Tuple{typeof(convert),Type{HomotopyContinuation.ModelKit.Interpreter{Float64,1}},HomotopyContinuation.ModelKit.Interpreter{Float64,1}})
    Base.precompile(Tuple{typeof(convert),Type{HomotopyContinuation.ModelKit.Interpreter{Float64,1}},HomotopyContinuation.ModelKit.Interpreter{Int64,1}})
    Base.precompile(Tuple{typeof(convert),Type{HomotopyContinuation.ModelKit.Interpreter{Float64,2}},HomotopyContinuation.ModelKit.Interpreter{Float64,2}})
    Base.precompile(Tuple{typeof(convert),Type{HomotopyContinuation.ModelKit.Interpreter{Float64,2}},HomotopyContinuation.ModelKit.Interpreter{Int64,2}})
    Base.precompile(Tuple{typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Array{Expression,1},Base.RefValue{Array{Variable,1}}}}})
    Base.precompile(Tuple{typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(horner),Tuple{Array{Expression,1},Base.RefValue{Array{Variable,1}}}}})
    Base.precompile(Tuple{typeof(eltype),HomotopyContinuation.ModelKit.Interpreter{Float64,1}})
    Base.precompile(Tuple{typeof(eltype),HomotopyContinuation.ModelKit.Interpreter{Float64,2}})
    Base.precompile(Tuple{typeof(eltype),HomotopyContinuation.ModelKit.Interpreter{Int64,1}})
    Base.precompile(Tuple{typeof(eltype),HomotopyContinuation.ModelKit.Interpreter{Int64,2}})
    Base.precompile(Tuple{typeof(find_start_pair),InterpretedSystem{Float64}})
    Base.precompile(Tuple{typeof(fix_parameters),InterpretedSystem{Float64},Array{Float64,1}})
    Base.precompile(Tuple{typeof(getindex),HomotopyContinuation.ModelKit.DiffMap,Float64,Int64})
    Base.precompile(Tuple{typeof(getindex),HomotopyContinuation.ModelKit.DiffMap,Int64,Int64})
    Base.precompile(Tuple{typeof(merge!),Dict{Expression,Expression},Dict{Expression,Expression}})
    Base.precompile(Tuple{typeof(newton),InterpretedSystem{Float64},Array{Complex{Float64},1},Array{Complex{Float64},1},InfNorm,NewtonCache{HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}})
    Base.precompile(Tuple{typeof(on_affine_chart),InterpretedSystem{Float64},Nothing})
    Base.precompile(Tuple{typeof(parameters),MonodromyResult{Array{Complex{Float64},1},Array{Complex{Float64},1}}})
    Base.precompile(Tuple{typeof(permute!),Array{Expression,1},Array{Int64,1}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Pair{Symbol,Tuple{Symbol,Float64,Symbol}}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Pair{Symbol,Tuple{Symbol,Int64,Symbol}}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Pair{Symbol,Tuple{Symbol,Symbol,Int64}}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Pair{Symbol,Tuple{Symbol,Symbol,Symbol}}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Tuple{Symbol,Float64,Symbol}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Tuple{Symbol,Int64,Int64}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Tuple{Symbol,Symbol,Float64}})
    Base.precompile(Tuple{typeof(push!),HomotopyContinuation.ModelKit.InstructionList,Tuple{Symbol,Symbol,Nothing}})
    Base.precompile(Tuple{typeof(setindex!),Dict{Expression,Irrational},Irrational{:catalan},Expression})
    Base.precompile(Tuple{typeof(setindex!),Dict{Expression,Irrational},Irrational{:γ},Expression})
    Base.precompile(Tuple{typeof(setindex!),Dict{Expression,Irrational},Irrational{:π},Expression})
    Base.precompile(Tuple{typeof(setindex!),Dict{Expression,Irrational},Irrational{:ℯ},Expression})
    Base.precompile(Tuple{typeof(setindex!),HomotopyContinuation.ModelKit.DiffMap,Float64,Symbol,Int64})
    Base.precompile(Tuple{typeof(setindex!),HomotopyContinuation.ModelKit.DiffMap,Symbol,Symbol,Int64})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(HomotopyContinuation.ModelKit.sort_key),Tuple{Base.Broadcast.Extruded{Array{Variable,1},Tuple{Bool},Tuple{Int64}}}},Type{Tuple{String,Array{Int64,1}}}})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Type{Tuple{Array{Int32,2},Array{Complex{Float64},1}}}})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(exponents_coefficients),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Type{Tuple{Array{Int32,2},Array{Float64,1}}}})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(horner),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}},Base.RefValue{Array{Variable,1}}}},Type{Expression}})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Type{Complex{Float64}}})
    Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(to_number),Tuple{Base.Broadcast.Extruded{Array{Expression,1},Tuple{Bool},Tuple{Int64}}}},Type{Int64}})
    Base.precompile(Tuple{typeof(size),AffineChartSystem{InterpretedSystem{Float64},1}})
    Base.precompile(Tuple{typeof(solutions),MonodromyResult{Array{Complex{Float64},1},Array{Complex{Float64},1}}})
    isdefined(HomotopyContinuation, Symbol("#221#222")) && Base.precompile(Tuple{getfield(HomotopyContinuation, Symbol("#221#222")),Array{Complex{Float64},1}})
    isdefined(HomotopyContinuation, Symbol("#283#285")) && Base.precompile(Tuple{getfield(HomotopyContinuation, Symbol("#283#285"))})
    isdefined(HomotopyContinuation, Symbol("#311#314")) && Base.precompile(Tuple{getfield(HomotopyContinuation, Symbol("#311#314"))})
    isdefined(HomotopyContinuation, Symbol("#312#315")) && Base.precompile(Tuple{getfield(HomotopyContinuation, Symbol("#312#315"))})
    isdefined(HomotopyContinuation.ModelKit, Symbol("#168#169")) && Base.precompile(Tuple{getfield(HomotopyContinuation.ModelKit, Symbol("#168#169")),Float64})
    isdefined(HomotopyContinuation.ModelKit, Symbol("#168#169")) && Base.precompile(Tuple{getfield(HomotopyContinuation.ModelKit, Symbol("#168#169")),Int64})
    isdefined(HomotopyContinuation.ModelKit, Symbol("#170#172")) && Base.precompile(Tuple{getfield(HomotopyContinuation.ModelKit, Symbol("#170#172")),Int64})
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.ModelKit.buildvar, (Expr,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Bool,typeof(HomotopyContinuation.ModelKit.buildvar),Expr,))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.ModelKit.buildvar, (Symbol,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Bool,typeof(HomotopyContinuation.ModelKit.buildvar),Symbol,))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (Solver{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Array{Complex{Float64},1},1},))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Function,Bool,Bool,Bool,typeof(solve),Solver{EndgameTracker{ParameterHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Array{Complex{Float64},1},1},))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (Solver{EndgameTracker{StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Array{Complex{Float64},1},1},))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Function,Bool,Bool,Bool,typeof(solve),Solver{EndgameTracker{StraightLineHomotopy{FixedParameterSystem{InterpretedSystem{Float64},Float64},InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Array{Complex{Float64},1},1},))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (Solver{OverdeterminedTracker{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},HomotopyContinuation.ExcessSolutionCheck{RandomizedSystem{InterpretedSystem{Float64}},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}}},Array{Tuple{MixedSubdivisions.MixedCell,Array{Complex{Float64},1}},1},))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Function,Bool,Bool,Bool,typeof(solve),Solver{OverdeterminedTracker{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}},HomotopyContinuation.ExcessSolutionCheck{RandomizedSystem{InterpretedSystem{Float64}},HomotopyContinuation.MatrixWorkspace{Array{Complex{Float64},2}}}}},Array{Tuple{MixedSubdivisions.MixedCell,Array{Complex{Float64},1}},1},))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (Solver{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Tuple{MixedSubdivisions.MixedCell,Array{Complex{Float64},1}},1},))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Function,Bool,Bool,Bool,typeof(solve),Solver{PolyhedralTracker{HomotopyContinuation.ToricHomotopy{InterpretedSystem{Float64}},CoefficientHomotopy{InterpretedSystem{Float64}},Array{Complex{Float64},2}}},Array{Tuple{MixedSubdivisions.MixedCell,Array{Complex{Float64},1}},1},))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (System,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Bool,Bool,Bool,Nothing,Function,Nothing,typeof(identity),Nothing,Nothing,Base.Iterators.Pairs{Symbol,Any,Tuple{Symbol,Symbol},NamedTuple{(:compile, :start_system),Tuple{Bool,Symbol}}},typeof(solve),System,))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (System,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Bool,Bool,Bool,Nothing,Function,Nothing,typeof(identity),Nothing,Nothing,Base.Iterators.Pairs{Symbol,Bool,Tuple{Symbol},NamedTuple{(:compile,),Tuple{Bool}}},typeof(solve),System,))
        end
    end
    let fbody = try __lookup_kwbody__(which(HomotopyContinuation.solve, (System,Vararg{Any,N} where N,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Bool,Bool,Bool,Array{Float64,1},Function,Nothing,typeof(identity),Nothing,Nothing,Base.Iterators.Pairs{Symbol,Any,Tuple{Symbol,Symbol},NamedTuple{(:start_parameters, :compile),Tuple{Array{Complex{Float64},1},Bool}}},typeof(solve),System,Vararg{Any,N} where N,))
        end
    end
end
