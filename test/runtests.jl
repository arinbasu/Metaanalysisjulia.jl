using MetaanalysisJulia
using Test

@testset "MetaanalysisJulia.jl" begin
    # start with a data frame
study = ["Carroll", "Grant", "Peck", "Donat", "Stewart", "Young"]
trt_mean = [94, 98, 98, 94, 98, 96]
trt_sd = [22, 21, 28, 19, 21, 21]
trt_n = [60, 65, 40, 200, 50, 85]
ctl_mean = [92, 92, 88, 82, 88, 92]
ctl_sd = [20, 22, 26, 17, 22, 22]
ctl_n = [60, 65, 40, 200, 45, 85]
df = DataFrame(
    "study" => study,
    "trt_mean" => trt_mean,
    "trt_sd" => trt_sd,
    "trt_n" => trt_n,
    "ctl_mean" => ctl_mean,
    "ctl_sd" => ctl_sd,
    "ctl_n" => ctl_n

)
# df



## Prepare the data
# Apply these two functions to create two variables

## variable y
df.y = gIndGrps.(df.trt_mean, df.ctl_mean, df.trt_sd, df.ctl_sd, 
df.trt_n, df.ctl_n )
# variable v
df.v = vgIndGrps.(df.trt_mean, df.ctl_mean, df.trt_sd, df.ctl_sd, 
df.trt_n, df.ctl_n)

## select these two variables
df2 = select(df, :study, :y, :v)

# We will work with this
# write the function for fixed effects model




# test fixed effects model 
@test MetaanalysisJulia.fixedEffects(df.y, df.v)

# Now write the random effects model



# test tausq works
@test MetaanalysisJulia.tausq(df.y, df.v)

# Now write the random effects model function



# test for random effects
@test MetaanalysisJulia.randEffects(df.y, df.v)

# fixed effects weights
df.wf = 1 ./ df.v
df.se = sqrt.(df.v)
df.relwf = (df.wf ./ sum(df.wf)) * 100
# random effects weights
df.wr = 1 ./ (df.v .+ tausq(df.y, df.v) )
df.relwr = (df.wr ./ sum(df.wr)) * 100
# show
select(df, :study, :y, :wf, :relwf, :relwr)



# forestPlot(df.study, df.y, df.v)

# the width of the diamond is based on the weight assigned to the diamond
# this weight is inverse of the variance of the diamond

# Write the function for heterogeneity



@test MetaanalsisJulia.isq(df.study, df.y, df.v)


end
