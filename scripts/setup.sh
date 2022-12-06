#!/bin/bash
# reads the config file and sets up the environment
# $1: the path to the config file

# check if the config file exists
if [ ! -f $1 ]; then
    echo "Config file not found";
    exit 1;
fi

echo "Setting up the environment...$1";
# read the config file
source $1;
# if it fail to read the config file exit
if [ $? -ne 0 ]; then
    echo "Failed to read the config file";
    exit 1;
fi

# get the project name from the config file
project_name=$PROJECT_NAME;
# remove the new line character from the project name
project_name=${project_name::-1};

# get the project version from the config file
project_version=$PROJECT_VERSION;
# remove the new line character from the project version
project_version=${project_version::-1};

# get the project description from the config file
project_description=$PROJECT_DESCRIPTION;
# remove the new line character from the project description
project_description=${project_description::-1};


# prnit the project name
echo "Project name: $project_name";

# print the project version
echo "Project version: ${project_version::1}";

# print the project description
echo "Project description: $project_description";

# replace the old project name with the new one inside the CMakeLists.txt file "project(\*)" is the old project name and "$project_name" is the new one
sed -i "s/project(.*)/project($project_name)/g" ../CMakeLists.txt;

# replace the old project Major with the new one inside the CMakeLists.txt file "set(${PROJECT_NAME}_VERSION_MAJOR .*)" is the old project version and "$project_version" is the new one
sed -i "s/set(\${PROJECT_NAME}_VERSION_MAJOR.*)/set(\${PROJECT_NAME}_VERSION_MAJOR ${project_version:0:1})/g" ../CMakeLists.txt;

# replace the old project Minor with the new one inside the CMakeLists.txt file "set(${PROJECT_NAME}_VERSION_MINOR .*)" is the old project version and "$project_version" is the new one
sed -i "s/set(\${PROJECT_NAME}_VERSION_MINOR.*)/set(\${PROJECT_NAME}_VERSION_MINOR ${project_version:2:1})/g" ../CMakeLists.txt;

# replace the old project Patch with the new one inside the CMakeLists.txt file "set(${PROJECT_NAME}_VERSION_PATCH .*)" is the old project version and "$project_version" is the new one
sed -i "s/set(\${PROJECT_NAME}_VERSION_PATCH.*)/set(\${PROJECT_NAME}_VERSION_PATCH ${project_version:4:1})/g" ../CMakeLists.txt;

# replace the old project description with the new one inside the CMakeLists.txt file "set(PROJECT_DESCRIPTION .*)" is the old project description and "$project_description" is the new one
sed -i "s/set(PROJECT_DESCRIPTION.*)/set(PROJECT_DESCRIPTION \"$project_description\")/g" ../CMakeLists.txt;




### edit .codedocs file
# replace the old project name with the new one inside the .codedocs file "PROJECT_NAME.*" is the old project name and "$project_name" is the new one
sed -i "s/PROJECT_NAME.*/PROJECT_NAME = \"$project_name\"/g" ../.codedocs;

# replace the old project version with the new one inside the .codedocs file "PROJECT_VERSION.*" is the old project version and "$project_version" is the new one
sed -i "s/PROJECT_NUMBER.*/PROJECT_NUMBER = $project_version/g" ../.codedocs;

# replace the old project description with the new one inside the .codedocs file "PROJECT_DESCRIPTION.*" is the old project description and "$project_description" is the new one
sed -i "s/PROJECT_BRIEF.*/PROJECT_BRIEF = \"$project_description\"/g" ../.codedocs;



# get the old project name folder inside include folder
old_project_name=$(ls ../include);        

# if its the same project name exit
if [ "$old_project_name" == "$project_name" ]; then
    echo "The project name is the same";
    exit 0;
fi
# print the old project name
echo "Old project name: $old_project_name";
# edit the folder name inside include folder with the new project name
mv ../include/$old_project_name ../include/$project_name;

# edit the include header inside all the source files with the new project name
sed -i "s/$old_project_name/$project_name/g" ../src/*.cpp;

# edit the include header inside all the test files with the new project name
sed -i "s/$old_project_name/$project_name/g" ../test/*.cpp;

# edit the project name in the run.sh file
sed -i "s/$old_project_name/$project_name/g" run.sh;


