class AWarriorEnemyCharacter : AWarriorBaseCharacter
{
	UPROPERTY(DefaultComponent, Category = "Combat")
	UEnemyCombatComponent EnemyCombatComponent;

	UPROPERTY(DefaultComponent, Category = "UI")
	UEnemyUIComponent EnemyUIComponent;

	UPROPERTY(DefaultComponent, Category = "UI")
	UWidgetComponent EnemyHealthComponent;

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		AutoPossessAI = EAutoPossessAI::PlacedInWorldOrSpawned;

		bUseControllerRotationPitch = false;
		bUseControllerRotationRoll = false;
		bUseControllerRotationYaw = false;

		CharacterMovement.bUseControllerDesiredRotation = false;
		CharacterMovement.bOrientRotationToMovement = true;
		CharacterMovement.RotationRate = FRotator(0.f, 180.0f, 0.f);
		CharacterMovement.MaxWalkSpeed = 300.f;
		CharacterMovement.BrakingDecelerationWalking = 1000.f;
	}

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		Super::BeginPlay();

		UWarriorWidgetBase EnemyWidget = Cast<UWarriorWidgetBase>(EnemyHealthComponent.Widget);
		if (EnemyWidget != nullptr)
		{
			EnemyWidget.InitEnemyCreatedWidget(this);
		}
	}

	UFUNCTION(BlueprintOverride)
	void Possessed(AController NewController)
	{
		Super::Possessed(NewController);
		InitEnemyStartupData();
	}

	void InitEnemyStartupData() {

		if (CharacterStartupData.IsNull())
			return;

		CharacterStartupData.LoadAsync(FOnSoftObjectLoaded(this, n"OnStartupDataLoaded"));
	}

	UFUNCTION()
	void OnStartupDataLoaded(UObject LoadedObject) {
		auto startupdata = Cast<UDataAsset_StartupDataBase>(LoadedObject);
		startupdata.GiveToAbilitySystemComponent(WarriorAbilitySystemComponent);
	}

	UPawnCombatComponent GetPawnCombatComponent() override
	{
		return EnemyCombatComponent;
	}

	// UI
	UPawnUIComponent GetUIComponent() override
	{
		return EnemyUIComponent;
	}
	UEnemyUIComponent GetEnemyUIComponent() override
	{
		return EnemyUIComponent;
	}
}