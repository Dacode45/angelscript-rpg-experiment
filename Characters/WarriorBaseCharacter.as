class AWarriorBaseCharacter : AAngelscriptGASCharacter
{

	UPROPERTY(Category = "CharacterData")
	TSoftObjectPtr<UDataAsset_StartupDataBase> CharacterStartupData;

	UAngelscriptAbilitySystemComponent GetWarriorAbilitySystemComponent() const property {
		return AbilitySystem;
	}

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		AbilitySystem.RegisterAttributeSet(UWarriorAttributeSet::StaticClass());
	}

	UFUNCTION(BlueprintOverride)
	void Possessed(AController NewController)
	{
		if (WarriorAbilitySystemComponent != nullptr)
		{
			WarriorAbilitySystemComponent.InitAbilityActorInfo(this, this);
			auto set = WarriorAbilitySystemComponent.RegisterAttributeSet(UWarriorAttributeSet::StaticClass());
			check(set != nullptr, "Failed to register attributes");

			auto _ = ensure(!CharacterStartupData.IsNull(), "Forgot to assign startup data");
		}
	}

	// Combat
	UPawnCombatComponent GetPawnCombatComponent()
	{
		check(false, "Subclass must override this");

		return nullptr;
	}

	// UI
	UPawnUIComponent GetUIComponent()
	{
		check(false, "Child Class needs to override");
		return nullptr;
	}
	UHeroUIComponent GetHeroUIComponent()
	{
		return nullptr;
	}
	UEnemyUIComponent GetEnemyUIComponent()
	{
		return nullptr;
	}
}