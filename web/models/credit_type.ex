defmodule OpenPantry.CreditType do
  use OpenPantry.Web, :model
  alias OpenPantry.Facility
  alias OpenPantry.FoodGroup
  alias OpenPantry.Stock
  schema "credit_types" do
    field :name, :string
    field :credits_per_period, :integer
    field :period_name, :string
    many_to_many :food_groups, FoodGroup, join_through: "credit_type_memberships", join_keys: [credit_type_id: :id, food_group_id: :foodgroup_code]
    has_many :foods, through: [:food_groups, :foods]
    has_many :stocks, through: [:foods, :stocks]
    has_many :facilities, through: [:stocks, :facility]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :credits_per_period, :period_name])
    |> validate_required([:name, :credits_per_period, :period_name])
  end

  def facility(facility = %Facility{id: facility_id}) do
    now = DateTime.utc_now
    from(s in Stock,
    where: s.arrival < ^now,
    where: s.expiration > ^now,
    where: ^facility_id == s.facility_id)
    |> Repo.all()
  end
end

