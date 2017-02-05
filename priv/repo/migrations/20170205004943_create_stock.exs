defmodule OpenPantry.Repo.Migrations.CreateStock do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :quantity, :integer
      add :arrival, :utc_datetime
      add :expiration, :utc_datetime
      add :reorder_quantity, :integer
      add :food_id, references(:foods, on_delete: :nothing)
      add :facility_id, references(:facilities, on_delete: :nothing)

      timestamps()
    end
    create index(:stocks, [:food_id])
    create index(:stocks, [:facility_id])

  end
end
