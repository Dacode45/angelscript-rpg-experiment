class AWarriorHeroWeaponBase : AWarriorWeaponBase
{
	UPROPERTY(Category = "WeaponData")
	FWarriorHeroWeaponData HeroWeaponData;

	UFUNCTION(BlueprintPure)
	void GetGrantedAbilityHandles(TArray<FGameplayAbilitySpecHandle>&out OutGrantedAbilities) {
		OutGrantedAbilities = GrantedAbilities;
	}

	UFUNCTION()
	void SetGrantedAbilityHandles(TArray<FGameplayAbilitySpecHandle>&in InGrantedAbilites) {
		GrantedAbilities = InGrantedAbilites;
	}

	private TArray<FGameplayAbilitySpecHandle> GrantedAbilities;
}