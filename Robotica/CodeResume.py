
import numpy as np
from numpy import random
import matplotlib.pyplot as plt
import scipy.stats as stats

######################## BLOQUE 1 ########################
# Chapter 02
# Genera n muestras de una distribucion normal con media mu y desviacion estandar sigma
mu = 0
sigma = 1
n = 1000
np.random.randn(n)*sigma + mu

# Funcion de densidad de una normal
mu = 0
sig = 1
X = np.linspace(-5, 5, 100) # 100 puntos entre -5 y 5
pdf1 = stats.norm(loc=mu, scale=sig).pdf(X) # funcion de densidad de una dimension

# Genera n muestras de una distribucion normal con media mu y desviacion estandar sigma
mu = 0
stdv = 1
n = 1000
samples = stats.norm(loc=mu, scale=stdv).rvs(n)

# Crea grafico de dispersion de los datos
num = 100
mu = 2
sigma = 2
plt.scatter(gen_samples(num, mu, sigma), np.zeros(num))

# Chapter 03
# Movimiento del robot por incremento de poses con ruido
def step(self, step_increment):
    """Computes a single step of our noisy robot.
        
        super().step(...) updates the expected pose (without noise)
        Generate a noisy increment based on step_increment and self.covariance.
        Then this noisy increment is applied to self.true_pose
    """
    super().step(step_increment)
    true_step = stats.multivariate_normal.rvs(step_increment.flatten(), self.covariance) # funcion de densidad de varias dimensiones
    self.true_pose = tcomp(self.true_pose, np.vstack(true_step))
      
# Movimiento del robot basado en velocidad
    
# Funcion next_pose, dos posibilidades, movimiento lineal o movimiento angular
def next_pose(x, u, dt, cov=None):
    'x: current pose [x, y, theta]'
    'u: differential command as a vector [v, w]'
    if cov is not None:
        u += np.sqrt(cov) @ random.randn(2, 1)
        #u = np.random.multivariate_normal(u.flatten(),cov)

    theta = x[2] # <-
    # Escribimos formulas para el movimiento lineal y el movimiento angular
    if u[1] == 0: #linear motion w=0
        next_x = np.vstack([x[0] + u[0] * dt * np.cos(theta), # <-
                            x[1] + u[0] * dt * np.sin(theta), # <-
                            x[2]])                            # <-

    else: #Non-linear motion w=!0
        R = u[0]/u[1] #v/w=r is the curvature radius
        delta = u[1]*dt
        next_x = np.vstack([x[0] - R*np.sin(theta) + R*np.sin(theta + delta), # <-
                            x[1] + R*np.cos(theta) - R*np.cos(theta + delta), # <-
                            x[2] + delta])                                    # <-
# Ahora con ruido, next_covariance
def next_covariance(x, P, Q, u, dt):
    ''' Compute the covariance of a robot following the velocity motion model

        Args:
            x: current pose (before movement)
            u: differential command as a vector [v, w]''
            dt: Time interval in which the movement occurs
            P: current covariance of the pose
            Q: covariance of our movement.
    '''
    # Aliases
    v = u[0, 0]
    w = u[1, 0]

    sx, cx = np.sin(x[2, 0]), np.cos(x[2, 0]) #sin and cos for the previous robot heading
    si, ci = np.sin(u[1, 0]*dt), np.cos(u[1, 0]*dt) #sin and cos for the heading increment
    R = u[0, 0]/u[1, 0] #v/w Curvature radius

    # cos(z + dt ) = cos(z)cos(dt) - sin(z)sin(dt)
    # sen(z + dt ) = cos(z)sen(dt) + sin(z)cos(dt
    if u[1, 0] == 0:  #linear motion w=0 --> R = infinite. Caso mas sencillo.
        #TODO JACOBIAN HERE.
        # Jacobiano con respecto a la pose previa x_{t-1}
        JacF_x = np.array([
            [1, 0, -v*dt*sx],
            [0, 1, v*dt*cx],
            [0, 0, 1]
        ])
        # Jacobiano con respecto al movimiento u_t
        JacF_u = np.array([
            [dt*cx, 0],
            [dt*sx, 0],
            [0, 0]
        ])
    else: #Non-linear motion w=!0. Caso mas complejo.
        JacF_x = np.array([
            [1, 0, R*(cx*ci - cx - sx*si)],
            [0, 1, R*(cx*si + sx*ci - sx)],
            [0, 0, 1]
        ])

        JacF_u = (
            np.array([
                [sx*ci - sx + cx*si, R*(cx*ci - sx*si)],
                [sx*si + cx* (1- ci), R*(sx*ci + cx*si)],
                [0, 1]
            ])@
            np.array([
                [1/w, -v/w**2],
                [0, dt]
            ])
        )
    #prediction steps
    Pt = (JacF_x @ P @ np.transpose(JacF_x)) + (JacF_u @ Q @ np.transpose(JacF_u)) # <-

    return Pt

# Movimiento del roboto basado en odometria
# Analitico
def generate_move(pose_now, pose_old):
    diff = pose_now - pose_old
    theta1 = np.arctan2(pose_now[1] - pose_old[1], pose_now[0] - pose_old[0]) - pose_old[2] # <-
    d = np.sqrt((pose_now[0] - pose_old[0])**2 + (pose_now[1] - pose_old[1])**2)  # <-
    theta2 = pose_now[2] - pose_old[2] - theta1 # <-
    return np.vstack((theta1, d, theta2))


# Chapter 04
def to_world_frame(p1_w, Qp1_w, z1_p_r, W1):
    # ...
    z1_car_rel = (
        np.vstack([r*c,r*s]), # position: r*cos(a), r*sin(a)
        Jac_pol_car @ W1 @ np.transpose(Jac_pol_car) # uncertainty  J*W*Jt
        )
    
    # ...
    z1_w = tcomp(p1_w ,z1_ext)[0:2,[0]] # Compute coordinates of the landmark in the world
    Wz1 = (Jac_ap @ Qp1_w @ np.transpose(Jac_ap)  # J*Q*Jt
          + Jac_aa @ z1_car_rel[1] @ np.transpose(Jac_aa))
    
# Chapter 05
# Localizacion por minimos cuadrados
#     Dimensions:
# Pose x:         (1, 1)
# Observations z: (5, 1)
# Obs. model H:   (5, 1)
# H.T@H:          (1, 1)
# inv(H.T@H):     (1, 1)
# H.T@z :         (1, 1)
x = np.linalg.inv(H.T @ H ) @ H.T @ z

# Localizacion por minimos cuadrados pesados
x_w =  np.linalg.inv(H.T @ np.linalg.inv(Q) @ H ) @ H.T @ np.linalg.inv(Q) @ z

zEst = distance(xEst, w_map)
e = z - zEst

######################## BLOQUE 2 ########################
# Chapter 06
def prediction_step(robot: EFKMappingRobot): 
    xPred = robot.xEst # como es estatico, la prediccion de los landmarks es la misma que la estimacion
    PPred = robot.PEst

def incorporate_new_landmark(robot: EFKMappingRobot, z, iLandmark, xPred, PPred):
    # ...
    xLandmark = robot.true_pose[0:2] + r * np.vstack([c, s])
    M = np.vstack([  
        np.hstack([np.eye(nStates), np.zeros((nStates, 2))]),
        np.hstack([np.zeros((2, nStates)), jGz])
    ])

    robot.PEst = M@linalg.block_diag(robot.PEst, robot.QEst)@M.T

def get_observation_jacobian(xPred, xLandmark):
    xdist = xLandmark[0, 0] - xPred[0, 0] # <-
    ydist = xLandmark[1, 0] - xPred[1, 0] # <-
    r = np.sqrt(xdist**2 + ydist**2) # <-
    r2 = r**2
    jHxl = np.array([
        [xdist/r , ydist/r],   # <-
        [-ydist/r2 , xdist/r2] # <-
    ])
    return jHxl

def update_step(robot, z, iLandmark, xPred, PPred):
    # KALMAN UPDATE IMPORTANT
    Innov = z-zPred # Innovation
    Innov[1] = AngleWrap(Innov[1])
    S = jH @ PPred @ jH.T + np.diag(np.tile(np.diag(robot.QEst), xLandmark.shape[0]//2))
    K = PPred @ jH.T @ linalg.inv(S) # Gain
    robot.xEst = xPred + K @ Innov    
    robot.PEst = (np.eye(robot.PEst.shape[0]) - K @ jH) @ PPred


# Chapter 07
    
def prediction_step(xVehicle, xMap, robot, u):
    # ...
    PPredvv = j1 @ robot.PEst[0:3,0:3] @ j1.T + j2 @ robot.cov_move @ j2.T 
    PPredvm = j1 @ robot.PEst[0:3,3:]
    PPredmm = robot.PEst[3:,3:]


def update_step(robot, sensor, xPred, PPred, xVehicle, z, iLandmark):
    S = jH@PPred@jH.T + sensor.cov_sensor
    W = PPred@jH.T@linalg.inv(S)
    robot.xEst = xPred+ W@Innov

    robot.PEst = PPred-W@S@W.T


# Chapter 08
def repulsive_force(xRobot, Map, RadiusOfInfluence, KObstacles):
    FRep = np.vstack(KObstacles * np.sum((1/d - 1/RadiusOfInfluence) * (1/(d ** 2)) * (p_to_object/d), axis=1))

def attractive_force(KGoal, GoalError):
    FAtt =  -KGoal * GoalError
    FAtt /= np.linalg.norm(GoalError) # Normalization

def main():
    # ...
    FTotal = FAtt + FRep