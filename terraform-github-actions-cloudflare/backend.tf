terraform {
  cloud {
    organization = "your-organisation-name"  

    workspaces {
      name = "your-workspace-name"
    }
  }
}