import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'starsmap.settings')
django.setup()

from django.core.management import call_command
from django.contrib.auth import get_user_model
from teams.models import Team, Employee, TargetEmployee, EmployeeTeam, RequestTraining, Level
from specialties.models import Position, Grade, Competence, Skill, RequirementPosition
from datetime import datetime, timedelta
import random

User = get_user_model()

def create_superuser():
    if not User.objects.filter(username='admin').exists():
        User.objects.create_superuser(
            username='admin',
            email='admin@starsmap.com',
            password='admin123'
        )
        print("✓ Superuser 'admin' created (password: admin123)")
    else:
        print("✓ Superuser already exists")

def create_mock_data():
    print("Creating mock data...")
    
    competencies = [
        ('Python Development', 'Technical'),
        ('JavaScript Development', 'Technical'),
        ('Database Management', 'Technical'),
        ('Project Management', 'Soft Skills'),
        ('Communication', 'Soft Skills'),
        ('Team Leadership', 'Soft Skills'),
    ]
    
    competence_objects = []
    for name, comp_type in competencies:
        comp, _ = Competence.objects.get_or_create(
            name=name,
            defaults={'type': comp_type}
        )
        competence_objects.append(comp)
    
    skills_data = {
        'Python Development': ['Django', 'FastAPI', 'Pytest', 'Asyncio'],
        'JavaScript Development': ['React', 'TypeScript', 'Node.js', 'Vue.js'],
        'Database Management': ['PostgreSQL', 'MongoDB', 'Redis', 'SQL Optimization'],
        'Project Management': ['Agile', 'Scrum', 'Planning', 'Risk Management'],
        'Communication': ['Presentation', 'Negotiation', 'Active Listening', 'Documentation'],
        'Team Leadership': ['Mentoring', 'Conflict Resolution', 'Motivation', 'Delegation'],
    }
    
    skill_objects = []
    for comp in competence_objects:
        if comp.name in skills_data:
            for skill_name in skills_data[comp.name]:
                skill, _ = Skill.objects.get_or_create(
                    name=skill_name,
                    competence=comp
                )
                skill_objects.append(skill)
    
    grades = ['Junior', 'Middle', 'Senior', 'Lead', 'Principal']
    grade_objects = []
    for grade_name in grades:
        grade, _ = Grade.objects.get_or_create(grade=grade_name)
        grade_objects.append(grade)
    
    positions = [
        'Backend Developer',
        'Frontend Developer',
        'Full Stack Developer',
        'DevOps Engineer',
        'QA Engineer',
        'Project Manager',
        'Team Lead',
        'Technical Lead',
    ]
    
    position_objects = []
    for pos_name in positions:
        pos, _ = Position.objects.get_or_create(name=pos_name)
        position_objects.append(pos)
    
    teams_data = [
        'Backend Team',
        'Frontend Team',
        'DevOps Team',
        'QA Team',
        'Platform Team',
    ]
    
    team_objects = []
    for team_name in teams_data:
        team, _ = Team.objects.get_or_create(name=team_name)
        team_objects.append(team)
    
    first_names = ['Иван', 'Петр', 'Мария', 'Анна', 'Дмитрий', 'Елена', 'Сергей', 'Ольга', 'Андрей', 'Наталья']
    last_names = ['Иванов', 'Петров', 'Сидоров', 'Козлов', 'Смирнов', 'Васильев', 'Михайлов', 'Федоров', 'Новиков', 'Морозов']
    
    employee_objects = []
    for i in range(20):
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        position = random.choice(position_objects)
        grade = random.choice(grade_objects[:3])
        bus_factor = random.choice([True, False])
        
        employee, created = Employee.objects.get_or_create(
            first_name=first_name,
            last_name=last_name,
            defaults={
                'position': position,
                'grade': grade,
                'bus_factor': bus_factor,
            }
        )
        if created:
            employee_objects.append(employee)
            
            team = random.choice(team_objects)
            EmployeeTeam.objects.get_or_create(
                team=team,
                employee=employee
            )
            
            if random.choice([True, False]):
                target_grade = random.choice(grade_objects[1:])
                target_position = random.choice(position_objects)
                TargetEmployee.objects.get_or_create(
                    employee=employee,
                    defaults={
                        'position': target_position,
                        'grade': target_grade,
                    }
                )
            
            for skill in random.sample(skill_objects, min(5, len(skill_objects))):
                level_name = random.choice(['Начинающий', 'Базовый', 'Продвинутый', 'Экспертный'])
                evaluation = random.choice(['Отлично', 'Хорошо', 'Удовлетворительно'])
                
                Level.objects.get_or_create(
                    employee=employee,
                    skill=skill,
                    defaults={
                        'data': datetime.now().date() - timedelta(days=random.randint(0, 365)),
                        'evaluation': evaluation,
                        'name': level_name,
                    }
                )
            
            if random.choice([True, False, False]):
                skill = random.choice(skill_objects)
                RequestTraining.objects.get_or_create(
                    employee=employee,
                    skill=skill,
                    defaults={
                        'desired_result': f'Достичь уровня {random.choice(["Продвинутый", "Экспертный"])}',
                        'start_date': datetime.now().date() + timedelta(days=random.randint(1, 30)),
                        'end_date': datetime.now().date() + timedelta(days=random.randint(60, 180)),
                        'status': random.choice(['Новый', 'В процессе', 'Одобрен', 'Отклонен']),
                    }
                )
    
    for position in position_objects:
        for grade in grade_objects:
            skills_for_req = random.sample(skill_objects, min(3, len(skill_objects)))
            for skill in skills_for_req:
                RequirementPosition.objects.get_or_create(
                    position=position,
                    grade=grade,
                    skill=skill,
                    defaults={
                        'rating': random.randint(1, 10),
                    }
                )
    
    print(f"✓ Created {Competence.objects.count()} competencies")
    print(f"✓ Created {Skill.objects.count()} skills")
    print(f"✓ Created {Grade.objects.count()} grades")
    print(f"✓ Created {Position.objects.count()} positions")
    print(f"✓ Created {Team.objects.count()} teams")
    print(f"✓ Created {Employee.objects.count()} employees")
    print(f"✓ Created {Level.objects.count()} skill levels")
    print(f"✓ Created {RequestTraining.objects.count()} training requests")

if __name__ == '__main__':
    print("Initializing database...")
    create_superuser()
    create_mock_data()
    print("✓ Database initialization complete!")
