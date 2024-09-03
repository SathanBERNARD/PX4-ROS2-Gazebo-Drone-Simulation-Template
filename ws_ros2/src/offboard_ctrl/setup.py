from setuptools import find_packages, setup

package_name = 'offboard_ctrl'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='cre',
    maintainer_email='cre@todo.todo',
    description='TODO: Package description',
    license='BSD 3-Clause',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'offboard_ctrl_example = offboard_ctrl.offboard_ctrl_example:main'
        ],
    },
)
