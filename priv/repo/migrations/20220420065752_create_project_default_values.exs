defmodule KrystalMathApi.Repo.Migrations.CreateProjectDefaultValues do
  use Ecto.Migration
  import Ecto.Query, warn: false
  alias KrystalMathApi.Repo
  alias KrystalMathApi.Projects.CategoriesAndImportance.{ProjectType,Priority,Status,ProjectCategoryType}
  alias KrystalMathApi.Operations.{UserStatus, TaskStatus}
  import Ecto.Changeset
  use Ecto.Schema

  def up do
     #Project type records (default records)
     Repo.insert(%ProjectCategoryType{name: "Operational"})
     Repo.insert(%ProjectCategoryType{name: "Strategic"})

    #Project type records (default records)
     Repo.insert(%ProjectType{name: "BET Projects"})
     Repo.insert(%ProjectType{name: "Country"})
     Repo.insert(%ProjectType{name: "Customer Journey"})
     Repo.insert(%ProjectType{name: "Integrations"})
     Repo.insert(%ProjectType{name: "Payment Methods /Gateways"})
     Repo.insert(%ProjectType{name: "Digital Marketing"})
     Repo.insert(%ProjectType{name: "BETSoftware Partners"})

     #default Priority Records
     Repo.insert(%Priority{name: "Low",level: "success"})
     Repo.insert(%Priority{name: "Medium",level: "info"})
     Repo.insert(%Priority{name: "HIGH",level: "warning"})
     Repo.insert(%Priority{name: "URGENT ATTENTION",level: "danger"})

     #defaul Project Status
     Repo.insert(%Status{name: "Not Started",effect: 15,level: "danger"})
     Repo.insert(%Status{name: "Planning",effect: 25,level: "dark"})
     Repo.insert(%Status{name: "Under Investigation",effect: 40,level: "warning"})
     Repo.insert(%Status{name: "On Hold",effect: 50,level: "warning"})
     Repo.insert(%Status{name: "In Progress",effect: 60,level: "primary"})
     Repo.insert(%Status{name: "Dev Completed",effect: 70,level: "info"})
     Repo.insert(%Status{name: "QA",effect: 80,level: "secondary"})
     Repo.insert(%Status{name: "Deployed",effect: 100,level: "success"})

    #Default User Statuses
    Repo.insert(%UserStatus{name: "Not Available"})
    Repo.insert(%UserStatus{name: "Loaned Out"})
    Repo.insert(%UserStatus{name: "Waiting For Dependency"})
    Repo.insert(%UserStatus{name: "Available"})
    Repo.insert(%UserStatus{name: "Completed"})

    #Default Task Statuses
    Repo.insert(%TaskStatus{name: "Not Started",level: "danger"})
    Repo.insert(%TaskStatus{name: "On Hold",level: "warning"})
    Repo.insert(%TaskStatus{name: "In Progress",level: "primary"})
    Repo.insert(%TaskStatus{name: "Testing",level: "secondary"})
    Repo.insert(%TaskStatus{name: "Completed",level: "success"})
  end




  def down do

    execute """
    delete  from project_types cascade;
    """
    execute """
    delete  from project_category_types cascade;
    """
    execute """
    delete  from project_types cascade;
    """
  
    execute """
    delete  from project_statuses cascade;
    """

    execute """ 
      delete  from user_statuses cascade;
      """
 
      execute """ 
      delete  from task_statuses cascade;
      """
  end
end
