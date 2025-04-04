class AWarriorBaseCharacter : AAngelscriptGASCharacter
{
	UPROPERTY(DefaultComponent, Category = "AbilitySystem")
	UWarriorAbilitySystemComponent WarriorAbilitySystemComponent;

	UPROPERTY(Category = "CharacterData")
	TSoftObjectPtr<UDataAsset_StartupDataBase> CharacterStartupData;

	UFUNCTION(BlueprintOverride)
	void BeginPlay(){
		AbilitySystem.RegisterAttributeSet(UWarriorAttributeSet::StaticClass());
	}

	UFUNCTION(BlueprintOverride)
	void Possessed(AController NewController)
	{
		if (WarriorAbilitySystemComponent != nullptr)
		{
			WarriorAbilitySystemComponent.InitAbilityActorInfo(this, this);
			auto _ = ensure(!CharacterStartupData.IsNull(), "Forgot to assign startup data");
		}
	}

	UPawnCombatComponent GetPawnCombatComponent()
	{
		check(false, "Subclass must override this");

		return nullptr;
	}
}