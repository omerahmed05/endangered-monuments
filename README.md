# Endangered Monuments Digital Catalog

A web-based application developed for CS 4604 (Introduction to Database Management Systems) to support the preservation of endangered Egyptian monuments. This project was created in collaboration with Dr. Hamouda to help archaeologists track discovered archaeological entities and generate statistical data for identifying monuments threatened by climate change.

## Project Overview

The Endangered Monuments Digital Catalog is a comprehensive database management system that facilitates the tracking, management, and analysis of Egyptian monuments. The system provides different interfaces for archaeologists and researchers to interact with monument data, ensuring proper documentation and preservation efforts.

## Features

### For Archaeologists (Admin)
- Create, delete, and edit admin accounts
- Manage monument records (create, update, delete)
- Manage researcher accounts
- Add condition notes for monuments
- Generate comprehensive statistical data for each user (guest, admin/archaelogist, researcher) using SQL aggregate functions.
- Monitor excavation projects
- Track monument locations and status

### For Researchers
- Create and manage personal accounts
- Browse monument records
- Bookmark important monuments
- Export monument data
- View statistical information
- Track excavation projects
- Access detailed monument information

## Database Structure

### Entities
1. **Archaeologist**
   - Administrators who manage the database and monument records
   - Responsible for overseeing excavation projects and researchers

2. **City**
   - Represents monument locations within Egypt
   - Used for categorizing and filtering monuments

3. **Monument**
   - Core entity storing details about endangered monuments
   - Includes information about condition, location, and associated projects

4. **Researcher**
   - Users who study and analyze monument data
   - Can bookmark and export monument information

5. **Excavation Project**
   - Tracks ongoing archaeological efforts
   - Associated with specific monuments and locations

6. **Bookmark**
   - Stores researcher's bookmarked monuments
   - Links researchers to their saved monuments

7. **Research**
   - Tracks which researchers are working on which excavation projects
   - Maintains research relationships

### Relationships
- **Located**: Monuments ↔ Cities
- **Contains**: Excavation Projects ↔ Monuments
- **Hosts**: Cities ↔ Excavation Projects
- **Supervise**: Archaeologists ↔ Excavation Projects
- **Manage**: Archaeologists ↔ Researchers
- **Research**: Researchers ↔ Excavation Projects
- **Bookmark**: Researchers ↔ Monuments

## Technical Implementation

- **Frontend**: HTML, CSS, JavaScript, Bootstrap
- **Backend**: Python with Flask
- **Database**: MySQL
- **Features**:
  - Dark/Light mode support
  - Responsive design
  - Secure authentication (passwords are encrypted, can also change password)
  - Data export functionality
  - Statistical analysis tools
  - Bookmarking system

## Team Members
- Omer Ahmed (omera@vt.edu)
- Cristian Chihuan (crsitianc@vt.edu)
- Greer Mello (greer@vt.edu)

## Getting Started

### Prerequisites
- Required Python packages (install using `pip install -r requirements.txt`)

### Setup Instructions
1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Configure MySQL database connection in `connections.py`
4. Run the application: `python connections.py`
5. Access the application at `http://localhost:5000`

### Quick Access
1. The guest user view is the default.
2. To sign in as an archaeologist (admin), use the following credentials:
   - Username: testUser
   - Password: password
