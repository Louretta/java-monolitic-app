PET CLINIC PROJECT

Project work flow 
![archi-](https://github.com/Louretta/career-project/assets/124626623/aca5d3a0-3c99-46b8-9efa-5cfd776e56c7)





High Availability and Scalability
To achieve high availability and scalability, the application is deployed across multiple AWS Availability Zones. This setup ensures data replication and failover capabilities in case of a zone-level failure. An Auto Scaling group is configured to automatically scale the application instances based on incoming traffic, ensuring optimal resource utilization and responsiveness.
An Elastic Load Balancer (ELB) distributes incoming traffic across multiple instances, providing load balancing and fault tolerance. 

CI/CD Pipeline
The project employs a robust CI/CD pipeline using Jenkins. Jenkins integrates with the GitHub repository to automatically fetch new commits from the production branch. Upon receiving a new commit, the pipeline executes several steps: SonarQube performs static code analysis; Maven compiles the code, runs unit tests, and packages the application; Jenkins runs OWASP Dependency Check for vulnerability scanning; and Maven-built artifacts are stored in the Nexus Repository. Jenkins also builds Docker images, pushes them to the Nexus Repository, and triggers an Ansible playbook to automate the deployment of the application on provisioned instances

Automated Deployment with Ansible
Ansible plays a crucial role in automating the deployment process. It is designed to discover new instances in the AWS account, update the dynamic host inventory, and trigger the deployment of the application on newly provisioned instances. The Ansible playbook defines a set of tasks and roles to handle the deployment process, including steps for application configuration, dependency installation, container deployment, and other necessary setup tasks.

Nexus Repository
Nexus serves as both the artifact repository and Docker image registry. Maven uses Nexus to store and manage build artifacts. During the CI/CD pipeline, Maven locates the pom.xml file, downloads all dependencies, runs unit tests, and packages the application into an artifact. Jenkins then pushes these artifacts to Nexus for centralized management and storage.

 SSL
 This setup improves application availability and reliability. SSL certificates are used to secure the servers, ensuring encrypted communication between the clients and the application, thereby enhancing security

Database and Secret Management
An AWS RDS instance is used to store persistent customer information. This setup ensures that new instances spawned by the Auto Scaling group can access consistent data. Additionally, Vault is used to securely store secrets and sensitive information. RDS is configured for read and write operations to ensure data persistence and consistency across instances.

Monitoring with New Relic
New Relic is installed to monitor both the application and infrastructure layers. It provides alerts for errors, memory usage, and other critical metrics. Memory usage alerts are particularly important in this setup due to the single-container configuration, which can max out available memory.
