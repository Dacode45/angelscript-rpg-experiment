USTRUCT()
struct FWarriorHeroWeaponData
{
	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly)
	TSubclassOf<UWarriorHeroLinkedAnimInstance> WeaponAnimLayerToLink;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly)
	UInputMappingContext WeaponInputMappingContext;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Meta = (TitleProperty = "InputTag"))
	TArray<FWarriorHeroAbilitySet> DefaultWeaponAbilities;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly)
	FScalableFloat WeaponBaseDamage;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly)
	TSoftObjectPtr<UTexture2D> WeaponIconImage;

}

USTRUCT()
struct FWarriorHeroAbilitySet
{
	UPROPERTY()
	FGameplayTag InputTag;

	UPROPERTY()
	TSubclassOf<UWarriorGameplayAbility> AbilityToGrant;

	bool IsValid() const {
		return InputTag.IsValid() && AbilityToGrant != nullptr;
	}
}