#include "logger.h"

/*******************************************************************************
 * Constructor. Initializes params / subscribers.
 */
Logger::Logger(void) : ground_truths_(0),
                       first_ground_truth_time_ (0),
                       goal_sent_(false)
{
  loadParams();

  ground_truth_sub_ = nodehandle_.subscribe(ground_truth_topic_, 10,
    &Logger::groundTruthCallback, this);

  amcl_pose_sub_ = nodehandle_.subscribe(amcl_pose_topic_, 10,
    &Logger::amclPoseCallback, this);

  icp_corrected_pose_sub_ = nodehandle_.subscribe(icp_corrected_pose_topic_, 10,
    &Logger::icpCorrectedPoseCallback, this);

  dft_corrected_pose_sub_ = nodehandle_.subscribe(dft_corrected_pose_topic_, 10,
    &Logger::dftCorrectedPoseCallback, this);

  execution_times_sub_ = nodehandle_.subscribe(execution_times_topic_, 10,
    &Logger::executionTimesCallback, this);

  map_sub_ = nodehandle_.subscribe(map_topic_, 1,
    &Logger::mapCallback, this);

  goal_pub_ = nodehandle_.advertise<geometry_msgs::PoseStamped>(
    "/move_base_simple/goal", 1);

  initLogfiles();

  ROS_INFO("[Logger] Node initialised");
}


/*******************************************************************************
 * Destructor
 */
Logger::~Logger(void)
{
  ROS_INFO("[Logger] Node destroyed");
}


/*******************************************************************************
 * Logs the amcl pose of the robot.
 */
void Logger::amclPoseCallback(
  const geometry_msgs::PoseWithCovarianceStamped& msg)
{
  logPose(msg, amcl_pose_filename_);
}


/*******************************************************************************
 * Logs the dft-corrected pose of the robot.
 */
void Logger::dftCorrectedPoseCallback(
  const geometry_msgs::PoseWithCovarianceStamped& msg)
{
  logPose(msg, dft_corrected_pose_filename_);
}


/*******************************************************************************
 * Logs the dft-corrected pose of the robot.
 */
void Logger::executionTimesCallback(const std_msgs::Duration& msg)
{
  std::ofstream file(execution_times_filename_.c_str(), std::ios::app);
  if (file.is_open())
  {
    file << msg.data.sec;
    file << ",";
    file << msg.data.nsec << std::endl;
    file.close();
  }
  else
    ROS_ERROR("[Pipeline evaluator] Could not log execution times");
}


/*******************************************************************************
 * Logs the ground truth pose of the robot.
 */
void Logger::groundTruthCallback(const nav_msgs::Odometry& msg)
{
  ground_truths_++;
  geometry_msgs::PoseWithCovarianceStamped ground_truth_pose;

  ground_truth_pose.header.stamp = msg.header.stamp;
  ground_truth_pose.pose = msg.pose;

  if (send_goal_)
  {
    if (ground_truths_ == 1)
      first_ground_truth_time_ = msg.header.stamp.sec;

    if (first_ground_truth_time_ + 15 < ros::Time::now().toSec() && !goal_sent_)
      sendGoal();
  }


  if (map_name_.compare("corridor") == 0)
  {
    // resolution: 0.025 m/cell
    //ground_truth_pose.pose.pose.position.x += 12.2;
    //ground_truth_pose.pose.pose.position.y += 8.2;

    // resolution: 0.01 m/cell
    ground_truth_pose.pose.pose.position.x += 11.56;
    ground_truth_pose.pose.pose.position.y += 8.2;

    // resolution: 0.005 m/cell
    //ground_truth_pose.pose.pose.position.x += 11.56;
    //ground_truth_pose.pose.pose.position.y += 8.04;
  }

  if (map_name_.compare("willowgarage") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 60.2;
    ground_truth_pose.pose.pose.position.y += 55.9;
  }

  if (map_name_.compare("square") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 11.4;
    ground_truth_pose.pose.pose.position.y += 11.4;
  }

  if (map_name_.compare("rectangle") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 11.24;
    ground_truth_pose.pose.pose.position.y += 11.24;
  }

  if (map_name_.compare("rectangle_long") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 12.2;
    ground_truth_pose.pose.pose.position.y += 14.6;
  }

  if (map_name_.compare("triangle") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 16.2;
    ground_truth_pose.pose.pose.position.y += 11.4;
  }

  if (map_name_.compare("gamma") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 13.0;
    ground_truth_pose.pose.pose.position.y += 12.2;
  }

  if (map_name_.compare("home_karto") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 10.613582;
    ground_truth_pose.pose.pose.position.y += 12.422026;
  }

  if (map_name_.compare("warehouse_karto") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 2.083190;
    ground_truth_pose.pose.pose.position.y += 3.015576;
  }

  if (map_name_.compare("cylinder") == 0)
  {
    ground_truth_pose.pose.pose.position.x += 8.58615;
    ground_truth_pose.pose.pose.position.y += 9.976414;
  }

  logPose(ground_truth_pose, ground_truth_filename_);
}


/*******************************************************************************
 * Logs the icp-corrected pose of the robot.
 */
void Logger::icpCorrectedPoseCallback(
  const geometry_msgs::PoseWithCovarianceStamped& msg)
{
  logPose(msg, icp_corrected_pose_filename_);
}


/*******************************************************************************
 * Create the logfiles and register the headers.
 */
void Logger::initLogfiles(void)
{
  // Header for all logs
  std::string header_str = "sec, nsec, position.x, position.y, orientation.yaw";

  // Create the ground truth file
  std::ofstream ground_truth_file(ground_truth_filename_.c_str());
  if (ground_truth_file.is_open())
  {
    ground_truth_file << header_str << std::endl;
    ground_truth_file.close();
  }
  else
    ROS_ERROR("[Logger] Ground truth file not open");

  // Create the amcl pose file
  std::ofstream amcl_pose_file(amcl_pose_filename_.c_str());
  if (amcl_pose_file.is_open())
  {
    amcl_pose_file << header_str << std::endl;
    amcl_pose_file.close();
  }
  else
    ROS_ERROR("[Logger] amcl pose file not open");

  // Create the icp-corrected pose file
  std::ofstream icp_corrected_pose_file(icp_corrected_pose_filename_.c_str());
  if (icp_corrected_pose_file.is_open())
  {
    icp_corrected_pose_file << header_str << std::endl;
    icp_corrected_pose_file.close();
  }
  else
    ROS_ERROR("[Logger] icp-corrected pose file not open");

  // Create the dft-corrected pose file
  std::ofstream dft_corrected_pose_file(dft_corrected_pose_filename_.c_str());
  if (dft_corrected_pose_file.is_open())
  {
    dft_corrected_pose_file << header_str << std::endl;
    dft_corrected_pose_file.close();
  }
  else
    ROS_ERROR("[Logger] dft-corrected pose file not open");

  // Create the execution-times file
  std::ofstream execution_times_file(execution_times_filename_.c_str());
  if (execution_times_file.is_open())
  {
    std::string header = "exec_sec, exec_nsec";
    execution_times_file << header << std::endl;
    execution_times_file.close();
  }
  else
    ROS_ERROR("[Logger] execution-times file not open");

  // Create the map file
  std::ofstream map_file(map_filename_.c_str());

  if (map_file.is_open())
  {
    map_file << "occupied_x, occupied_y" << std::endl;
    map_file.close();
  }
  else
    ROS_ERROR("[Logger] Map file not open");
}


/*******************************************************************************
 * Param loader. Check logger.h
 */
void Logger::loadParams(void)
{
  // Get topic names
  nodehandle_.getParam(ros::this_node::getName() + "/ground_truth_topic",
    ground_truth_topic_);
  nodehandle_.getParam(ros::this_node::getName() + "/amcl_pose_topic",
    amcl_pose_topic_);
  nodehandle_.getParam(ros::this_node::getName() + "/icp_corrected_pose_topic",
    icp_corrected_pose_topic_);
  nodehandle_.getParam(ros::this_node::getName() + "/dft_corrected_pose_topic",
    dft_corrected_pose_topic_);
  nodehandle_.getParam(ros::this_node::getName() + "/execution_times_topic",
    execution_times_topic_);
  nodehandle_.getParam(ros::this_node::getName() + "/map_topic", map_topic_);

  // Get log filenames
  nodehandle_.getParam(ros::this_node::getName() + "/ground_truth_filename",
    ground_truth_filename_);
  nodehandle_.getParam(ros::this_node::getName() + "/amcl_pose_filename",
    amcl_pose_filename_);
  nodehandle_.getParam(ros::this_node::getName() + "/icp_corrected_pose_filename",
    icp_corrected_pose_filename_);
  nodehandle_.getParam(ros::this_node::getName() + "/dft_corrected_pose_filename",
    dft_corrected_pose_filename_);
  nodehandle_.getParam(ros::this_node::getName() + "/execution_times_filename",
    execution_times_filename_);
  nodehandle_.getParam(ros::this_node::getName() + "/map_filename",
    map_filename_);

  // Get goal pose
  nodehandle_.getParam(ros::this_node::getName() + "/map_name", map_name_);

  nodehandle_.getParam(ros::this_node::getName() + "/send_goal", send_goal_);
  nodehandle_.getParam(ros::this_node::getName() + "/goal_x", goal_x_);
  nodehandle_.getParam(ros::this_node::getName() + "/goal_y", goal_y_);
  nodehandle_.getParam(ros::this_node::getName() + "/goal_yaw", goal_yaw_);
}


/*******************************************************************************
 * Logs a pose
 */
void Logger::logPose(const geometry_msgs::PoseWithCovarianceStamped& msg,
  const std::string& filename)
{
  std::ofstream file(filename.c_str(), std::ios::app);

  tf::Quaternion q(
    msg.pose.pose.orientation.x,
    msg.pose.pose.orientation.y,
    msg.pose.pose.orientation.z,
    msg.pose.pose.orientation.w);

  q.normalize();

  tf::Matrix3x3 m(q);
  double roll, pitch, yaw;
  m.getRPY(roll, pitch, yaw);

  if (file.is_open())
  {
    file << msg.header.stamp.sec;
    file << ", ";
    file << msg.header.stamp.nsec;
    file << ", ";
    file << msg.pose.pose.position.x;
    file << ", ";
    file << msg.pose.pose.position.y;
    file << ", ";
    file << yaw << std::endl;

    file.close();
  }
  else
    ROS_ERROR("[Pipeline evaluator] Could not log pose");
}

/*******************************************************************************
 * Logs the map
 */
void Logger::mapCallback(const nav_msgs::OccupancyGrid& msg)
{
  std::ofstream map_file(map_filename_.c_str(), std::ios::app);

  if (map_file.is_open())
  {
    map_resolution_ = msg.info.resolution;
    map_height_ = msg.info.height;
    map_width_ = msg.info.width;
    map_origin_x_ = msg.info.origin.position.x;
    map_origin_y_ = msg.info.origin.position.y;

    for (int i = 0; i < map_height_; i++)
    {
      for (int j = 0; j < map_width_; j++)
      {
        unsigned int id = i * map_width_ + j;
        int cell = msg.data[id];

        if (cell == 100)
        {
          map_file << map_origin_x_ + j * map_resolution_;
          map_file << ", ";
          map_file << map_origin_y_ + i * map_resolution_;
          map_file << std::endl;
        }
      }
    }

    map_file.close();
  }
}


/*******************************************************************************
 * Sends the given goal to the robot.
 */
void Logger::sendGoal(void)
{
  geometry_msgs::PoseStamped goal_msg;
  goal_msg. header.frame_id = "map";

  tf::Quaternion q = tf::createQuaternionFromRPY(0.0, 0.0, goal_yaw_);

  goal_msg.pose.position.x = goal_x_;
  goal_msg.pose.position.y = goal_y_;
  goal_msg.pose.position.z = 0.0;

  tf::quaternionTFToMsg(q, goal_msg.pose.orientation);

  goal_pub_.publish(goal_msg);

  goal_sent_ = true;

  ROS_INFO("[Pipeline Evaluation] Goal sent!");
}
