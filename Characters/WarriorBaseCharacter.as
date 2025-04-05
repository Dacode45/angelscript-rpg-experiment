class AWarriorBaseCharacter : AAngelscriptGASCharacter
{

	UPROPERTY(Category = "CharacterData")
	TSoftObjectPtr<UDataAsset_StartupDataBase> CharacterStartupData;

	UAngelscriptAbilitySystemComponent GetWarriorAbilitySystemComponent() const property {
		return AbilitySystem;
	}

	// UFUNCTION(BlueprintOverride)
	// void ConstructionScript(){
	// 	AbilitySystem = UWarriorAbilitySystemComponent::Create(this);
	// }

	// UWarriorAbilitySystemComponent GetWarriorAbilitySystemComponent() const property {
	// 	return Cast<UWarriorAbilitySystemComponent>(AbilitySystem);
	// }

	UFUNCTION(BlueprintOverride)
	void Possessed(AController NewController)
	{
		if (WarriorAbilitySystemComponent != nullptr)
		{
			WarriorAbilitySystemComponent.InitAbilityActorInfo(this, this);
			auto set = WarriorAbilitySystemComponent.RegisterAttributeSet(UWarriorAttributeSet::StaticClass());
			check(set != nullptr, "Failed to register attributes");

			auto _ = ensure(!CharacterStartupData.IsNull(), "Forgot to assign startup data");

			WarriorAbilitySystemComponent.OnAttributeChanged.AddUFunction(this, n"OnAttributeChanged");
			WarriorAbilitySystemComponent.SetAttributeBaseValue(UWarriorAttributeSet, n"MaxHealth", 1030);
		}
	}

	// THIS NEVER GETS CALLED ????
	UFUNCTION()
	void OnAttributeChanged(const FAngelscriptModifiedAttribute&in AttributeChangeData){
		Debug::Print(f"Attribute Changed: {AttributeChangeData.Name}: {AttributeChangeData.OldValue} -> {AttributeChangeData.NewValue}");
	}

	UPawnCombatComponent GetPawnCombatComponent()
	{
		check(false, "Subclass must override this");

		return nullptr;
	}
}