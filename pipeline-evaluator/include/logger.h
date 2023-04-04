#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <fstream>

#include "ros/ros.h"
#include "tf/transform_datatypes.h"
#include "geometry_msgs/PoseStamped.h"
#include "geometry_msgs/PoseWithCovarianceStamped.h"
#include "nav_msgs/OccupancyGrid.h"
#include "nav_msgs/Odometry.h"
#include "std_msgs/Duration.h"



class Logger
{
  private:
    ros::NodeHandle nodehandle_;

    //
    int ground_truths_;
    int first_ground_truth_time_;
    bool goal_sent_;

    // List subscribers
    ros::Subscriber ground_truth_sub_;
    ros::Subscriber amcl_pose_sub_;
    ros::Subscriber icp_corrected_pose_sub_;
    ros::Subscriber dft_corrected_pose_sub_;
    ros::Subscriber execution_times_sub_;
    ros::Subscriber map_sub_;

    // Goal publisher
    ros::Publisher goal_pub_;

    // List subscribed topics
    std::string ground_truth_topic_;
    std::string amcl_pose_topic_;
    std::string icp_corrected_pose_topic_;
    std::string dft_corrected_pose_topic_;
    std::string execution_times_topic_;
    std::string map_topic_;

    // List logfile filenames
    std::string ground_truth_filename_;
    std::string amcl_pose_filename_;
    std::string icp_corrected_pose_filename_;
    std::string dft_corrected_pose_filename_;
    std::string execution_times_filename_;
    std::string map_filename_;

    std::string map_name_;
    float map_resolution_;
    int map_height_;
    int map_width_;
    int map_origin_x_;
    int map_origin_y_;

    // The goal pose
    bool send_goal_;
    double goal_x_;
    double goal_y_;
    double goal_yaw_;

    // Callbacks
    void groundTruthCallback(const nav_msgs::Odometry& msg);
    void amclPoseCallback(const geometry_msgs::PoseWithCovarianceStamped& msg);
    void icpCorrectedPoseCallback(const geometry_msgs::PoseWithCovarianceStamped& msg);
    void dftCorrectedPoseCallback(const geometry_msgs::PoseWithCovarianceStamped& msg);
    void executionTimesCallback(const std_msgs::Duration& msg);
    void mapCallback(const nav_msgs::OccupancyGrid& msg);

    // Init / helpers
    void loadParams();
    void initLogfiles();
    void sendGoal();
    void logPose(const geometry_msgs::PoseWithCovarianceStamped& msg,
      const std::string& filename);


  public:
    Logger(void);
    ~Logger(void);

};

#endif // LOGGER_H
